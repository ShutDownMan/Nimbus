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
exports.EquationHandler = void 0;
const superstruct_1 = require("superstruct");
const handler_error_1 = require("../handler-error/handler-error");
const prisma_1 = __importDefault(require("../prisma"));
const EquationInsertModel = (0, superstruct_1.object)({
    equation: (0, superstruct_1.string)(),
    description: (0, superstruct_1.string)(),
    sensor: (0, superstruct_1.optional)((0, superstruct_1.string)()),
    measurementUnit: (0, superstruct_1.optional)((0, superstruct_1.string)()),
});
/**
 * Handler for the equation insertion
 * @param req
 * @param res
 * @param next
 * @returns
 */
function EquationHandler(req, res, next) {
    return __awaiter(this, void 0, void 0, function* () {
        /// first validate request body
        let reqBody = yield validateEquation(req, res, next);
        /// if it failed valiation
        if (!reqBody) {
            /// return an error status code
            let errorRes = {
                message: "Bad Request, couldn't validate data.",
                type: handler_error_1.HandlerErrors.ValidationError
            };
            return res.status(403).json(errorRes);
        }
        const prisma = prisma_1.default.getInstance().prisma;
        /// separate sensor and measurement unit code from request body
        let { sensor: sensorCode, measurementUnit: measurementUnitCode } = reqBody;
        let sensor = null;
        let measurementUnit = null;
        /// if both sensor and measurement unit were given
        if (sensorCode && measurementUnitCode) {
            /// find them both
            sensor = yield prisma.sensor.findUnique({
                where: {
                    code: sensorCode
                }
            });
            measurementUnit = yield prisma.measurementUnit.findUnique({
                where: {
                    code: measurementUnitCode
                }
            });
            if (!sensor || !measurementUnit) {
                /// return an error status code
                let errorRes = {
                    message: "Bad Request, could not find sensor or measurement unit",
                    type: handler_error_1.HandlerErrors.DatabaseError
                };
                console.debug("Couldn't find sensor or measurement unit");
                console.debug(sensor);
                console.debug(measurementUnit);
                return res.status(403).json(errorRes);
            }
        }
        /// insert new equation on the database
        let equationData = Object.assign({ equation: reqBody.equation, description: reqBody.description }, (sensor && measurementUnit && {
            Sensor_MeasurementUnit: {
                connect: {
                    id_MeasurementUnit_id_Sensor: {
                        id_Sensor: sensor.id,
                        id_MeasurementUnit: measurementUnit.id,
                    }
                }
            }
        }));
        try {
            yield prisma.sensorMeasurementConversion.create({
                data: equationData,
            });
        }
        catch (error) {
            /// return an error status code
            let errorRes = {
                message: "Bad Request, could not insert equation.",
                type: handler_error_1.HandlerErrors.DatabaseError
            };
            console.debug(error);
            return res.status(403).json(errorRes);
        }
        return res.status(200).json({ message: "equation was inserted sucessfully" });
    });
}
exports.EquationHandler = EquationHandler;
/**
 * Validate an object containing the needed equation information
 * @param req
 * @param res
 * @param next
 * @returns null if couldn't validate and the body if validate correctly
 */
function validateEquation(req, res, next) {
    return __awaiter(this, void 0, void 0, function* () {
        console.debug("Handling Stations");
        console.debug(req.body);
        let reqBody = req.body;
        /// validate input
        try {
            (0, superstruct_1.assert)(reqBody, EquationInsertModel);
        }
        catch (error) {
            console.log("Error trying to insert stations: ", error);
            return null;
        }
        return reqBody;
    });
}
