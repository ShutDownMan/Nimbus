import { optional, array, assert, object, record, string, number, boolean } from 'superstruct'
import { MeasuredData, Prisma } from "@prisma/client";
import { NextFunction, Request, Response } from "express";
import { HandlerError, HandlerErrors } from "../handler-error/handler-error";
import PrismaGlobal from "../prisma";
import { evaluate } from "mathjs";

const MeasuredValueInsertModel = object({
    timestamp: number(),
    value: number()
});

const MeasurementUnitInsertModel = record(
    string(),
    array(MeasuredValueInsertModel)
);

const SensorInsertModel = record(
    string(),
    MeasurementUnitInsertModel
);

const StationInsertModel = record(
    string(),
    SensorInsertModel
);

const StationDeleteModel = object({
    code: string()
});

const StationMetadataModel = object({
    code: string(),
    description: optional(string()),
    latitude: optional(number()),
    longitude: optional(number()),
    altitude: optional(number()),
    active: optional(boolean()),
    deactivationTS: optional(string()),
});

/**
 * Endpoint for data insertion from a collection of stations
 * @param req 
 * @param res 
 * @param next 
 * @returns 
 */
export async function StationHandler(req: Request, res: Response, next: NextFunction): Promise<any> {
    console.debug("Handling Stations");
    console.debug(req.body);

    let reqBody = req.body;
    /// validate input
    try {
        assert(reqBody, StationInsertModel);
    } catch (error) {
        console.log("Error trying to insert stations: ", error);

        let errorRes: HandlerError = {
            message: "Bad Request, couldn't validate data.",
            error_type: HandlerErrors.ValidationError
        };

        return res.status(400).json(errorRes);
    }

    const prisma = PrismaGlobal.getInstance().prisma;

    /// for each station
    for (let kv_station of Object.entries(req.body)) {
        /// get station code and station list
        let stationCode: string = kv_station[0].padStart(12, "0").slice(0, 12)
        let sensors: any = kv_station[1]

        /// prepare station for insertion if needed
        console.debug(`running through station "${stationCode}"`);
        let stationData: Prisma.StationCreateInput = {
            code: stationCode
        };

        /// for each sensor in the station
        for (let kv_sensor of Object.entries(sensors)) {
            /// get sensor code and measurement units list
            let sensorCode: string = kv_sensor[0].padStart(2, "0").slice(0, 2)
            let measurementUnits: any = kv_sensor[1]

            /// prepare sensor for insertion if needed
            console.debug(`running through sensor "${sensorCode}"`);
            let sensorData: Prisma.SensorCreateInput = {
                code: sensorCode,
            };

            /// for each measurement unit in the sensor
            for (let kv_measurementUnit of Object.entries(measurementUnits)) {
                /// get sensor code and measurement units list
                let measurementUnitCode: string = kv_measurementUnit[0].padStart(2, "0").slice(0, 2)
                let measuredValues: any = kv_measurementUnit[1]

                console.debug(`running through measurementUnit "${measurementUnitCode}"`);

                let measurementUnitData: Prisma.MeasurementUnitCreateInput = {
                    code: measurementUnitCode,
                };

                let measureDataCode = stationCode + sensorCode + measurementUnitCode;

                console.debug(measureDataCode)

                /// for each measured value
                for (let measuredValue of measuredValues) {
                    // measurementUnit.insertMeasuredValue(measuredValue);
                    let timestamp: number = Number(measuredValue["timestamp"]);
                    let value: number = Number(measuredValue["value"]);

                    console.debug(`inserting value "${value}" from ${timestamp}`);

                    let station_Sensor_MeasurementUnitData: Prisma.Station_Sensor_MeasurementUnitCreateInput = {
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

                    let measuredData: Prisma.MeasuredDataCreateInput = {
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
                        let measuredDataInserted = await prisma.measuredData.create({
                            data: measuredData
                        });

                        dataConvertionHandler(measuredDataInserted, sensorCode, measurementUnitCode);

                    } catch (error: any) {
                        console.debug(error);
                        // return res.status(403).json({ message: "Could not insert measured data" });
                    }
                }
            }
        }
    }

    return res.status(202).json({ message: "station data were inserted sucessfully" });
}

/**
 * handler for data convertion using the equations in the database
 * @param measuredData measured data from sensor
 * @param sensorCode sensor code
 * @param measurementUnitCode measurement unit
 */
async function dataConvertionHandler(measuredData: MeasuredData, sensorCode: string, measurementUnitCode: string) {
    const prisma = PrismaGlobal.getInstance().prisma;

    /// fetch SensorMeasurementConversion
    let sensorMeasurementUnit = await prisma.sensor_MeasurementUnit.findFirst({
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
    let convertionEquation = sensorMeasurementUnit?.SensorMeasurementConversion?.equation;

    if (convertionEquation) {
        /// evaluate giving the necessary inputs
        let convertedValue: number = evaluate(convertionEquation, { raw: measuredData.rawValue });

        /// update measured data with converted value
        await prisma.measuredData.update({
            where: {
                id: measuredData.id
            },
            data: {
                convertedValue: convertedValue
            }
        });

        console.log("Data was converted sucessfully");
    } else {
        console.log("No equation available for data conversion");
    }
}

export async function StationDeleteHandler(req: Request, res: Response, next: NextFunction): Promise<any> {
    console.debug("Handling Stations");
    console.debug(req.body);

    let reqBody = req.body;
    /// validate input
    try {
        assert(reqBody, StationDeleteModel);
    } catch (error) {
        console.log("Error trying to delete stations: ", error);
        
        let errorRes: HandlerError = {
            message: "Bad Request, couldn't validate data.",
            error_type: HandlerErrors.ValidationError
        };
        
        return res.status(400).json(errorRes);
    }

    const prisma = PrismaGlobal.getInstance().prisma;

    try {
        await prisma.station.delete({
            where: {
                code: reqBody.code,
            }
        });
    } catch (error) {
        console.log("Error trying to delete stations: ", error);
        
        let errorRes: HandlerError = {
            message: "Bad Request, couldn't delete data.",
            error_type: HandlerErrors.ValidationError
        };
        
        return res.status(400).json(errorRes);
    }

    return res.status(202).json({ message: "station data were deleted sucessfully" });
}

export async function StationMetadataHandler(req: Request, res: Response, next: NextFunction): Promise<any> {
    console.debug("Handling Station Metadata");
    console.debug(req.body);

    let reqBody = req.body;
    /// validate input
    try {
        assert(reqBody, StationMetadataModel);
    } catch (error) {
        console.log("Error trying to insert stations: ", error);

        let errorRes: HandlerError = {
            message: "Bad Request, couldn't validate data.",
            error_type: HandlerErrors.ValidationError
        };

        return res.status(400).json(errorRes);
    }

    const prisma = PrismaGlobal.getInstance().prisma;

    /// update station data
    let stationData: Prisma.StationUpdateInput = {
        code: reqBody.code,
        description: reqBody.description,
        active: reqBody.active,
        ...(reqBody.deactivationTS && {
            deactivationTS: new Date(Date.parse(reqBody.deactivationTS)),
        }),
    };

    /// update station general metadata
    try {
        let stationUpdated = await prisma.station.update({
            where: {
                code: reqBody.code,
            },
            data: stationData
        });
    
        /// updating station metadata latitude and longitude
        if(reqBody.latitude && reqBody.longitude) {
            await prisma.$executeRaw`UPDATE Station SET POINT(${reqBody.latitude}, ${reqBody.longitude}) WHERE code = ${reqBody.code}`;
        }
            
    } catch (error) {
        console.log("Error trying to update station: ", error);

        let errorRes: HandlerError = {
            message: "Bad Request, couldn't update station.",
            error_type: HandlerErrors.ValidationError
        };

        return res.status(400).json(errorRes);
    }
    
    return res.status(202).json({ message: "station metadata was updated sucessfully" });
}