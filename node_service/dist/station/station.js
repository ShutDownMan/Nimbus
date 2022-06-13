"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.StationHandler = void 0;
const superstruct_1 = require("superstruct");
const handler_error_1 = require("../handler-error/handler-error");
const prisma_1 = __importDefault(require("../prisma"));
const mathjs_1 = __importDefault(require("mathjs"));
const MeasuredValueInsertModel = (0, superstruct_1.object)({
    timestamp: (0, superstruct_1.number)(),
    value: (0, superstruct_1.number)()
});
const MeasurementUnitInsertModel = (0, superstruct_1.record)((0, superstruct_1.string)(), (0, superstruct_1.array)(MeasuredValueInsertModel));
const SensorInsertModel = (0, superstruct_1.record)((0, superstruct_1.string)(), MeasurementUnitInsertModel);
const StationInsertModel = (0, superstruct_1.record)((0, superstruct_1.string)(), SensorInsertModel);
/**
 * Endpoint for data insertion from a collection of stations
 * @param req
 * @param res
 * @param next
 * @returns
 */
function StationHandler(req, res, next) {
    return __awaiter(this, void 0, void 0, function* () {
        console.debug("Handling Stations");
        console.debug(req.body);
        let reqBody = req.body;
        /// validate input
        try {
            (0, superstruct_1.assert)(reqBody, StationInsertModel);
        }
        catch (error) {
            console.log("Error trying to insert stations: ", error);
            let errorRes = {
                message: "Bad Request, couldn't validate data.",
                type: handler_error_1.HandlerErrors.ValidationError
            };
            return res.status(403).json(errorRes);
        }
        const prisma = prisma_1.default.getInstance().prisma;
        /// for each station
        for (let kv_station of Object.entries(req.body)) {
            /// get station code and station list
            let stationCode = kv_station[0].padStart(12, "0").slice(0, 12);
            let sensors = kv_station[1];
            /// prepare station for insertion if needed
            console.debug(`running through station "${stationCode}"`);
            let stationData = {
                code: stationCode
            };
            /// for each sensor in the station
            for (let kv_sensor of Object.entries(sensors)) {
                /// get sensor code and measurement units list
                let sensorCode = kv_sensor[0].padStart(2, "0").slice(0, 2);
                let measurementUnits = kv_sensor[1];
                /// prepare sensor for insertion if needed
                console.debug(`running through sensor "${sensorCode}"`);
                let sensorData = {
                    code: sensorCode,
                };
                /// for each measurement unit in the sensor
                for (let kv_measurementUnit of Object.entries(measurementUnits)) {
                    /// get sensor code and measurement units list
                    let measurementUnitCode = kv_measurementUnit[0].padStart(2, "0").slice(0, 2);
                    let measuredValues = kv_measurementUnit[1];
                    console.debug(`running through measurementUnit "${measurementUnitCode}"`);
                    let measurementUnitData = {
                        code: measurementUnitCode,
                    };
                    let measureDataCode = stationCode + sensorCode + measurementUnitCode;
                    console.debug(measureDataCode);
                    /// for each measured value
                    for (let measuredValue of measuredValues) {
                        // measurementUnit.insertMeasuredValue(measuredValue);
                        let timestamp = Number(measuredValue["timestamp"]);
                        let value = Number(measuredValue["value"]);
                        console.debug(`inserting value "${value}" from ${timestamp}`);
                        let station_Sensor_MeasurementUnitData = {
                            code: measureDataCode,
                            MeasurementUnit: {
                                connectOrCreate: {
                                    where: {
                                        code: measurementUnitData.code
                                    },
                                    create: measurementUnitData
                                }
                            },
                            Sensor: {
                                connectOrCreate: {
                                    where: {
                                        code: sensorData.code
                                    },
                                    create: sensorData
                                }
                            },
                            Station: {
                                connectOrCreate: {
                                    where: {
                                        code: stationData.code
                                    },
                                    create: stationData
                                }
                            }
                        };
                        let measuredData = {
                            rawValue: Number(value),
                            timestamp: new Date(timestamp),
                            Station_Sensor_MeasurementUnit: {
                                connectOrCreate: {
                                    create: station_Sensor_MeasurementUnitData,
                                    where: {
                                        code: station_Sensor_MeasurementUnitData.code
                                    }
                                }
                            }
                        };
                        try {
                            let measuredDataInserted = yield prisma.measuredData.create({
                                data: measuredData
                            });
                            dataConvertionHandler(measuredDataInserted, sensorCode, measurementUnitCode);
                        }
                        catch (error) {
                            console.debug(error);
                            // return res.status(403).json({ message: "Could not insert measured data" });
                        }
                    }
                }
            }
        }
        return res.status(200).json({ message: "station data were inserted sucessfully" });
    });
}
exports.StationHandler = StationHandler;
/**
 * handler for data convertion using the equations in the database
 * @param measuredData measured data from sensor
 * @param sensorCode sensor code
 * @param measurementUnitCode measurement unit
 */
function dataConvertionHandler(measuredData, sensorCode, measurementUnitCode) {
    var _a;
    return __awaiter(this, void 0, void 0, function* () {
        const prisma = prisma_1.default.getInstance().prisma;
        /// fetch SensorMeasurementConversion
        let sensorMeasurementUnit = yield prisma.sensor_MeasurementUnit.findFirst({
            where: {
                Sensor: {
                    code: sensorCode
                },
                MeasurementUnit: {
                    code: measurementUnitCode
                }
            },
            select: {
                SensorMeasurementConversion: true
            }
        });
        /// get text equation from SensorMeasurementConversion
        let convertionEquation = (_a = sensorMeasurementUnit === null || sensorMeasurementUnit === void 0 ? void 0 : sensorMeasurementUnit.SensorMeasurementConversion) === null || _a === void 0 ? void 0 : _a.equation;
        if (convertionEquation) {
            /// evaluate giving the necessary inputs
            let convertedValue = mathjs_1.default.evaluate(convertionEquation, { raw: measuredData.rawValue });
            /// update measured data with converted value
            yield prisma.measuredData.update({
                where: {
                    id: measuredData.id
                },
                data: {
                    convertedValue: convertedValue
                }
            });
            console.log("Data was converted sucessfully");
        }
        else {
            console.log("No equation available for data conversion");
        }
    });
}
