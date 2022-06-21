import { prisma, Prisma } from "@prisma/client";
import { NextFunction, Request, Response } from "express";
import { object, string, assert, optional } from "superstruct";
import { HandlerError, HandlerErrors } from "../handler-error/handler-error";
import PrismaGlobal from "../prisma";

const EquationInsertModel = object({
    equation: string(),
    description: string(),
    sensor: optional(string()),
    measurementUnit: optional(string()),
});

const EquationDeleteModel = object({
    description: optional(string()),
    sensor: optional(string()),
    measurementUnit: optional(string()),
});


/**
 * Handler for the equation insertion
 * @param req 
 * @param res 
 * @param next 
 * @returns 
 */
export async function EquationInsertHandler(req: Request, res: Response, next: NextFunction): Promise<any> {
    /// first validate request body
    let reqBody = req.body;
    try {
        assert(reqBody, EquationInsertModel);
    } catch (error) {
        /// if it failed valiation
        console.log("Error trying to insert stations: ", error);

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
 * Handler for the equation insertion
 * @param req 
 * @param res 
 * @param next 
 * @returns 
 */
export async function EquationDeleteHandler(req: Request, res: Response, next: NextFunction): Promise<any> {
    /// first validate request body
    let reqBody = req.body;
    try {
        assert(reqBody, EquationDeleteModel);
    } catch (error) {
        /// if it failed valiation
        console.log("Error trying to delete stations: ", error);

        /// return an error status code
        let errorRes: HandlerError = {
            message: "Bad Request, couldn't validate data.",
            error_type: HandlerErrors.ValidationError
        };

        return res.status(400).json(errorRes);
    }

    const prisma = PrismaGlobal.getInstance().prisma;

    await prisma.sensorMeasurementConversion.deleteMany({
        where: {
            OR: {
                description: reqBody.description,
                Sensor_MeasurementUnit: {
                    some: {
                        Sensor: {
                            code: reqBody.sensor
                        },
                        MeasurementUnit: {
                            code: reqBody.measurementUnit
                        },
                    }
                },
            },
        }
    });

    return res.status(202).json({ message: "equation was deleted sucessfully" });
}