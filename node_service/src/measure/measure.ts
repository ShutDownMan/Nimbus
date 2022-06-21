import { NextFunction, Request, Response } from "express";
import { assert, number, object, optional, refine, string, union } from "superstruct";
import { HandlerErrors } from "../handler-error/handler-error";
import PrismaGlobal from "../prisma";

/// model for getting all clients
const MeasuresFetch = object({
    take: number(),
    page: optional(number()),
});

const MeasureFetchModel = object({
    code: string(),
});

const MeasureInsertModel = object({
    code: refine(string(), 'code', (v: string) => v.length === 2),
    name: string(),
    description: optional(string()),
});

const MeasurePatchModel = object({
    code: string(),
    name: optional(string()),
    description: optional(string()),
});

const MeasureDeleteModel = object({
    code: string(),
});

export async function MeasuresFetchHandler(req: Request, res: Response, next: NextFunction): Promise<any> {
    /// get prisma connection
    const prisma = PrismaGlobal.getInstance().prisma;

    let reqBody = req.body;
    /// validate input
    try {
        assert(reqBody, MeasuresFetch);
    } catch (error) {
        console.log("Error trying to get measures: ", error);

        return res.status(400).json({
            message: "Couldn't validate data.",
            error_type: HandlerErrors.ValidationError,
        });
    }

    /// getting records
    try {
        let measures = await prisma.measurementUnit.findMany({
            take: reqBody.take,
            ...(reqBody.page && {
                skip: reqBody.take * reqBody.page,
            }),
        });

        return res.status(202).json(measures)
    } catch (error) {
        console.log("Error trying to get measures: ", error);

        return res.status(500).json({
            message: "Database error when fetching measures.",
            error_type: HandlerErrors.DatabaseError,
        });
    }
    
}

/**
 * Handler for fetching measure
 * @param req 
 * @param res 
 * @param next 
 * @returns validation error or fetched measure
 */
export async function MeasureFetchHandler(req: Request, res: Response, next: NextFunction): Promise<any> {
    let reqBody = req.body;

    /// validate request body
    try {
        assert(reqBody, MeasureFetchModel);
    } catch (error) {
        return res.status(400).json({
            message: "Couldn't validate data.",
            error_type: HandlerErrors.ValidationError,
        });
    }

    /// get prisma connection
    const prisma = PrismaGlobal.getInstance().prisma;

    /// fetch measure data given in request
    let measure = await prisma.measurementUnit.findUnique({
        where: {
            code: reqBody.code,
        }
    });

    /// return sucess with fetched measure
    return res.status(202).json(measure);
}

/**
 * Handler for inserting new measure
 * @param req 
 * @param res 
 * @param next 
 * @returns validation error or newly added measure
 */
export async function MeasureInsertHandler(req: Request, res: Response, next: NextFunction): Promise<any> {
    let reqBody = req.body;

    /// validate request body
    try {
        assert(reqBody, MeasureInsertModel);
    } catch (error) {
        return res.status(400).json({
            message: "Couldn't validate data.",
            error_type: HandlerErrors.ValidationError,
        });
    }

    /// get prisma connection
    const prisma = PrismaGlobal.getInstance().prisma;

    /// persisting measure in database
    let measure = await prisma.measurementUnit.create({
        data: {
            code: reqBody.code,
            name: reqBody.name,
            description: reqBody.description,
        }
    });

    /// returning sucess message with newly added measure
    return res.status(202).json(measure);
}

/**
 * Handler for updating measure data
 * @param req 
 * @param res 
 * @param next 
 * @returns validation error or updated measure
 */
export async function MeasurePatchHandler(req: Request, res: Response, next: NextFunction): Promise<any> {
    let reqBody = req.body;

    /// validate request body
    try {
        assert(reqBody, MeasurePatchModel);
    } catch (error) {
        return res.status(400).json({
            message: "Couldn't validate data.",
            error_type: HandlerErrors.ValidationError,
        });
    }

    /// get prisma connection
    const prisma = PrismaGlobal.getInstance().prisma;

    /// update measure data given in request
    let measure = await prisma.measurementUnit.update({
        where: {
            code: reqBody.code,
        },
        data: {
            name: reqBody.name,
            description: reqBody.description,
        }
    });

    /// return sucess with updated measure
    return res.status(202).json(measure);
}

/**
 * Handler for deleting a measure
 * @param req 
 * @param res 
 * @param next 
 * @returns validation error or sucess message
 */
export async function MeasureDeleteHandler(req: Request, res: Response, next: NextFunction): Promise<any> {
    let reqBody = req.body;

    /// validate request body
    try {
        assert(reqBody, MeasureDeleteModel);
    } catch (error) {
        return res.status(400).json({
            message: "Couldn't validate data.",
            error_type: HandlerErrors.ValidationError,
        });
    }

    /// get prisma connection
    const prisma = PrismaGlobal.getInstance().prisma;

    let transactions = [];

    /// fetch measure data given in request
    transactions.push(prisma.measurementUnit.delete({
        where: {
            code: reqBody.code,
        }
    }));

    await prisma.$transaction(transactions);

    /// return sucess with fetched measure
    return res.status(202).json({ message: "measure deleted sucessfully." });
}
