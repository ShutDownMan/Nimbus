import { NextFunction, Request, Response } from "express";
import { assert, number, object, optional, refine, string, union } from "superstruct";
import { HandlerErrors } from "../handler-error/handler-error";
import PrismaGlobal from "../prisma";

const SensorFetchModel = object({
    code: string(),
});

const ManufacturerInsertModel = object({
    name: string(),
    country: string(),
})

const SensorInsertModel = object({
    code: refine(string(), 'code', (v: string) => v.length === 2),
    sku: optional(string()),
    lifespan: optional(string()),
    manufacturer: union([
        object({
            id: number()
        }),
        ManufacturerInsertModel,
    ]),
});

const SensorPatchModel = object({
    code: string(),
    sku: optional(string()),
    lifespan: optional(string()),
    manufacturer: optional(object({
        id: number()
    })),
});

const SensorDeleteModel = object({
    code: string(),
});

/**
 * Handler for fetching sensor
 * @param req 
 * @param res 
 * @param next 
 * @returns validation error or fetched sensor
 */
export async function SensorFetchHandler(req: Request, res: Response, next: NextFunction): Promise<any> {
    let reqBody = req.body;

    /// validate request body
    try {
        assert(reqBody, SensorFetchModel);
    } catch (error) {
        return res.status(400).json({
            message: "Couldn't validate data.",
            error_type: HandlerErrors.ValidationError,
        });
    }

    /// get prisma connection
    const prisma = PrismaGlobal.getInstance().prisma;

    /// fetch sensor data given in request
    let sensor = await prisma.sensor.findUnique({
        where: {
            code: reqBody.code,
        }
    });

    /// return sucess with fetched sensor
    return res.status(202).json(sensor);
}

/**
 * Handler for inserting new sensor
 * @param req 
 * @param res 
 * @param next 
 * @returns validation error or newly added sensor
 */
export async function SensorInsertHandler(req: Request, res: Response, next: NextFunction): Promise<any> {
    let reqBody = req.body;

    /// validate request body
    try {
        assert(reqBody, SensorInsertModel);
    } catch (error) {
        return res.status(400).json({
            message: "Couldn't validate data.",
            error_type: HandlerErrors.ValidationError,
        });
    }

    /// get prisma connection
    const prisma = PrismaGlobal.getInstance().prisma;

    /// get or create sensor manufacturer
    let manufacturerID = null;
    if ('id' in reqBody.manufacturer) {
        let manufacturer = await prisma.manufacturer.findUnique({
            where: {
                id: reqBody.manufacturer.id,
            }
        });

        manufacturerID = manufacturer?.id;
    } else if ('name' in reqBody.manufacturer) {
        let manufacturer = await prisma.manufacturer.create({
            data: {
                name: reqBody.manufacturer.name,
                Country: {
                    connect: {
                        code: reqBody.manufacturer.country,
                    }
                }
            }
        });

        manufacturerID = manufacturer?.id;
    }

    /// persisting sensor in database
    let sensor = await prisma.sensor.create({
        data: {
            code: reqBody.code,
            SKU: reqBody.sku,
            lifespan: reqBody.lifespan,
            id_Manufacturer: manufacturerID,
        }
    });

    /// returning sucess message with newly added sensor
    return res.status(202).json(sensor);
}

/**
 * Handler for updating sensor data
 * @param req 
 * @param res 
 * @param next 
 * @returns validation error or updated sensor
 */
export async function SensorPatchHandler(req: Request, res: Response, next: NextFunction): Promise<any> {
    let reqBody = req.body;

    /// validate request body
    try {
        assert(reqBody, SensorPatchModel);
    } catch (error) {
        return res.status(400).json({
            message: "Couldn't validate data.",
            error_type: HandlerErrors.ValidationError,
        });
    }

    /// get prisma connection
    const prisma = PrismaGlobal.getInstance().prisma;

    /// update sensor data given in request
    let sensor = await prisma.sensor.update({
        where: {
            code: reqBody.code,
        },
        data: {
            SKU: reqBody.sku,
            lifespan: reqBody.lifespan,
            Manufacturer: {
                connect: {
                    id: reqBody.manufacturer?.id,
                }
            },
        }
    });

    /// return sucess with updated sensor
    return res.status(202).json(sensor);
}

/**
 * Handler for deleting a sensor
 * @param req 
 * @param res 
 * @param next 
 * @returns validation error or sucess message
 */
export async function SensorDeleteHandler(req: Request, res: Response, next: NextFunction): Promise<any> {
    let reqBody = req.body;

    /// validate request body
    try {
        assert(reqBody, SensorDeleteModel);
    } catch (error) {
        return res.status(400).json({
            message: "Couldn't validate data.",
            error_type: HandlerErrors.ValidationError,
        });
    }

    /// get prisma connection
    const prisma = PrismaGlobal.getInstance().prisma;

    let transactions = [];

    /// fetch sensor data given in request
    transactions.push(prisma.sensor.delete({
        where: {
            code: reqBody.code,
        }
    }));

    await prisma.$transaction(transactions);

    /// return sucess with fetched sensor
    return res.status(202).json({ message: "sensor deleted sucessfully." });
}
