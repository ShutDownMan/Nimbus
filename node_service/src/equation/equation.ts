import { Prisma } from "@prisma/client";
import { NextFunction, Request, Response } from "express";
import { object, string, assert, optional } from "superstruct";
import { HandlerError, HandlerErrors } from "../handler-error/handler-error";
import PrismaGlobal from "../prisma";

const EquationInsertModel = object({
    equation: string(),
    description: string(),
    sensor: optional(string()),
    measurementUnit: optional(string()),
})

/**
 * Handler for the equation insertion
 * @param req 
 * @param res 
 * @param next 
 * @returns 
 */
export async function EquationHandler(req: Request, res: Response, next: NextFunction): Promise<any> {
    /// first validate request body
    let reqBody = await validateEquation(req, res, next);

    /// if it failed valiation
    if (!reqBody) {
        /// return an error status code
        let errorRes: HandlerError = {
            message: "Bad Request, couldn't validate data.",
            error_type: HandlerErrors.ValidationError
        };

        return res.status(400).json(errorRes);
    }

    const prisma = PrismaGlobal.getInstance().prisma;

    /// separate sensor and measurement unit code from request body
    let { sensor: sensorCode, measurementUnit: measurementUnitCode } = reqBody;
    let sensor = null;
    let measurementUnit = null;

    /// if both sensor and measurement unit were given
    if (sensorCode && measurementUnitCode) {
        /// find them both
        sensor = await prisma.sensor.findUnique({
            where: {
                code: sensorCode
            }
        });
        measurementUnit = await prisma.measurementUnit.findUnique({
            where: {
                code: measurementUnitCode
            }
        });

        if (!sensor || !measurementUnit) {
            /// return an error status code
            let errorRes: HandlerError = {
                message: "Bad Request, could not find sensor or measurement unit",
                error_type: HandlerErrors.DatabaseError
            };
            console.debug("Couldn't find sensor or measurement unit");
            console.debug(sensor);
            console.debug(measurementUnit);

            return res.status(400).json(errorRes);
        }
    }

    /// insert new equation on the database
    let equationData: Prisma.SensorMeasurementConversionCreateInput = {
        equation: reqBody.equation,
        description: reqBody.description,
        /// if sensor and measurement unit is given they are already connected
        ...(sensor && measurementUnit && {
            Sensor_MeasurementUnit: {
                connect: {
                    id_MeasurementUnit_id_Sensor: {
                        id_Sensor: sensor.id,
                        id_MeasurementUnit: measurementUnit.id,
                    }
                }
            }
        }),
    }

    try {
        await prisma.sensorMeasurementConversion.create({
            data: equationData,
        });
    } catch (error: any) {
        /// return an error status code
        let errorRes: HandlerError = {
            message: "Bad Request, could not insert equation.",
            error_type: HandlerErrors.DatabaseError
        };
        console.debug(error);

        return res.status(400).json(errorRes);
    }

    return res.status(202).json({ message: "equation was inserted sucessfully" });
}

/**
 * Validate an object containing the needed equation information
 * @param req 
 * @param res 
 * @param next 
 * @returns null if couldn't validate and the body if validate correctly
 */
async function validateEquation(req: Request, res: Response, next: NextFunction) {
    console.debug("Handling Stations");
    console.debug(req.body);

    let reqBody = req.body;
    /// validate input
    try {
        assert(reqBody, EquationInsertModel);
    } catch (error) {
        console.log("Error trying to insert stations: ", error);

        return null;
    }

    return reqBody;
}