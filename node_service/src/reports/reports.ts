import { MeasuredData, MeasurementUnit } from "@prisma/client";
import { NextFunction, Request, Response } from "express";
import { array, assert, number, object, optional, refine, string, union } from "superstruct";
import { HandlerErrors } from "../handler-error/handler-error";
import lodash from 'lodash';
import PrismaGlobal from "../prisma";

/// model for the report of a station
const ReportTodayFetch = object({
    station: string(),
    measures: optional(array(string())),
});

/*
    para cada grandeza [temperatura, umidade, pressao atmosferica, radiacao solar, vento media, vento rajadas, umidade solo, temperatura solo]
    {
        media manha
        media tarde
        media noite
        media madrugada
        media dia
    }

    {
        "__measure_code": {
            name: string,
            count: {
                madrugada: number,
                manha: number,
                tarde: number,
                noite: number,
                dia: number,
            },
            average: {},
            min: {},
            max: {},
            sum: {},
        },
    }

    para cada grandeza [temperatura, umidade, pressao atmosferica, radiacao solar, vento media, vento rajadas, umidade solo, temperatura solo]
    {
        valores
    }


    balanco hidrico
    grau dia - a partir do começo da plantacao

    TODO: MODELAR TALHÕES
    TODO: MODELAR TRABALHAMENTO DE DADOS
    TODO: MODELAR INICIO DE PLANTACAO
*/

export async function StationReportTodayFetchHandler(req: Request, res: Response, next: NextFunction): Promise<any> {
    /// get prisma connection
    const prisma = PrismaGlobal.getInstance().prisma;

    let reqBody = req.body;
    /// validate input
    try {
        assert(reqBody, ReportTodayFetch);
    } catch (error) {
        console.log("Error trying to get measures: ", error);

        return res.status(400).json({
            message: "Couldn't validate data.",
            error_type: HandlerErrors.ValidationError,
        });
    }

    /// get all measures from station
    let station_measures;
    try {
        /// my pyramid of doom
        /// it relates all the measures of a station
        station_measures = await prisma.sensor_MeasurementUnit.findMany({
            where: {
                Sensor: {
                    Station_Sensor: {
                        some: {
                            Station: {
                                code: reqBody.station,
                            }
                        }
                    }
                }
            },
            include: {
                MeasurementUnit: true,
                Sensor: true,
                SensorMeasurementConversion: true,
            }
        });
    } catch (error) {
        console.log("Error trying to get measures: ", error);

        return res.status(500).json({
            message: "Database error when fetching measures.",
            error_type: HandlerErrors.DatabaseError,
        });
    }

    /// remove duplicate measures by priority
    let groups_station_measures = lodash.groupBy(station_measures, (c) => c.MeasurementUnit.code);

    /// filter out the measures not specified
    let sorted_station_measures = lodash
        .map(groups_station_measures, (g) => {
            return g.sort((a, b) => (a.priority && b.priority && a.priority > b.priority) ? 1 : -1);
        });
    let filtered_station_measures = sorted_station_measures.map((g) => {
        return g.pop();
    });

    /// get all measured data from every measure from today
    let today = new Date();
    let today_start = new Date(today.getFullYear(), today.getMonth(), today.getDate(), 0, 0, 0);
    let today_end = new Date(today.getFullYear(), today.getMonth(), today.getDate(), 23, 59, 59);

    let measures_results: any = {};
    for (let measure of filtered_station_measures) {
        if (!measure) continue;
        let measured_data;
        try {
            measured_data = await prisma.measuredData.findMany({
                where: {
                    Station_Sensor_MeasurementUnit: {
                        Station: {
                            code: reqBody.station,
                        },
                        Sensor: {
                            code: measure.Sensor.code,
                        },
                        MeasurementUnit: {
                            code: measure.MeasurementUnit.code,
                        },
                    },
                    timestamp: {
                        gte: today_start,
                        lte: today_end,
                    }
                },
                orderBy: {
                    timestamp: "asc",
                },
            });
        } catch (error) {
            console.log("Error trying to get measured data: ", error);

            return res.status(500).json({
                message: "Database error when fetching measured data.",
                error_type: HandlerErrors.DatabaseError,
            });
        }

        /// calculate results for the whole day
        let measure_results = {
            day: {
                count: lodash.sumBy(measured_data, (c) => c ? 0 : 1),
                mean: lodash.meanBy(measured_data, (c) => c.convertedValue),
                high: lodash.maxBy(measured_data, (c) => c.convertedValue)?.convertedValue || 0,
                low: lodash.minBy(measured_data, (c) => c.convertedValue)?.convertedValue || 0,
                sum: lodash.sumBy(measured_data, (c) => Number(madrugada_check(c))),
            }
        };

        /// divide them up and calculate the results
        let today_start_milis = today_start.getTime();
        let day_quarters = {
            madrugada: [today_start_milis + 0, today_start_milis + (60 * 60 * 1000 * 0.25)],
            manha: [today_start_milis + (60 * 60 * 1000 * 0.25), today_start_milis + (60 * 60 * 1000 * 0.5)],
            tarde: [today_start_milis + (60 * 60 * 1000 * 0.5), today_start_milis + (60 * 60 * 1000 * 0.75)],
            noite: [today_start_milis + (60 * 60 * 1000 * 0.75), today_start_milis + (60 * 60 * 1000 * 1)],
        };

        /// check if timestamp is in the first quarter of the day
        const madrugada_check = (c: MeasuredData | null) => {
            return c && c.timestamp && c.timestamp.getTime() >= day_quarters.madrugada[0] && c.timestamp.getTime() <= day_quarters.madrugada[1];
        };

        /// check if timestamp is in the second quarter of the day
        const manha_check = (c: MeasuredData | null) => {
            return c && c.convertedValue && c.timestamp.getTime() >= day_quarters.manha[0] && c.timestamp.getTime() <= day_quarters.manha[1];
        };

        /// check if timestamp is in the third quarter of the day
        const tarde_check = (c: MeasuredData | null) => {
            return c && c.convertedValue && c.timestamp.getTime() >= day_quarters.tarde[0] && c.timestamp.getTime() <= day_quarters.tarde[1];
        };

        /// check if timestamp is in the fourth quarter of the day
        const noite_check = (c: MeasuredData | null) => {
            return c && c.convertedValue && c.timestamp.getTime() >= day_quarters.noite[0] && c.timestamp.getTime() <= day_quarters.noite[1];
        };

        /// calculate the results for each quarter
        let day_quarters_results = {
            madrugada: {
                count: measured_data.map((m): number => madrugada_check(m) ? 1 : 0).reduce((a, b) => a + b, 0),
                mean: lodash.meanBy(measured_data, madrugada_check),
                high: lodash.maxBy(measured_data, madrugada_check)?.convertedValue || 0,
                low: lodash.minBy(measured_data, madrugada_check)?.convertedValue || 0,
                sum: lodash.sumBy(measured_data, (c) => Number(madrugada_check(c))),
            },
            manha: {
                count: measured_data.map((m): number => manha_check(m) ? 1 : 0).reduce((a, b) => a + b, 0),
                mean: lodash.meanBy(measured_data, manha_check),
                high: lodash.maxBy(measured_data, manha_check)?.convertedValue || 0,
                low: lodash.minBy(measured_data, manha_check)?.convertedValue || 0,
                sum: lodash.sumBy(measured_data, (c) => Number(manha_check(c))),
            },
            tarde: {
                count: measured_data.map((m): number => tarde_check(m) ? 1 : 0).reduce((a, b) => a + b, 0),
                mean: lodash.meanBy(measured_data, tarde_check),
                high: lodash.maxBy(measured_data, tarde_check)?.convertedValue || 0,
                low: lodash.minBy(measured_data, tarde_check)?.convertedValue || 0,
                sum: lodash.sumBy(measured_data, (c) => Number(tarde_check(c))),
            },
            noite: {
                count: measured_data.map((m): number => noite_check(m) ? 1 : 0).reduce((a, b) => a + b, 0),
                mean: lodash.meanBy(measured_data, noite_check),
                high: lodash.maxBy(measured_data, noite_check)?.convertedValue || 0,
                low: lodash.minBy(measured_data, noite_check)?.convertedValue || 0,
                sum: lodash.sumBy(measured_data, (c) => Number(noite_check(c))),
            },
        };

        /// calculate the results for the last hour
        let last_hour_start = new Date(today_start.getTime() - (60 * 60 * 1000));
        let last_hour_end = new Date(today_start.getTime() - (60 * 60 * 1000));
        last_hour_end.setHours(last_hour_end.getHours() + 1);

        /// fetching the last hour data
        let last_hour_data;
        try {
            last_hour_data = await prisma.measuredData.findMany({
                where: {
                    Station_Sensor_MeasurementUnit: {
                        Station: {
                            code: reqBody.station,
                        },
                        Sensor: {
                            code: measure.Sensor.code,
                        },
                        MeasurementUnit: {
                            code: measure.MeasurementUnit.code,
                        },
                    },
                    timestamp: {
                        gte: last_hour_start,
                        lte: last_hour_end,
                    },
                },
                orderBy: {
                    timestamp: "asc",
                },
            });
        } catch (error) {
            console.log("Error trying to get measured data: ", error);

            return res.status(500).json({
                message: "Database error when fetching measured data.",
                error_type: HandlerErrors.DatabaseError,
            });
        }

        /// calculate results for the last hour
        let last_hour_results = {
            last_hour: {
                count: lodash.sumBy(last_hour_data, (c) => c ? 0 : 1),
                mean: lodash.meanBy(last_hour_data, (c) => c.convertedValue),
                high: lodash.maxBy(last_hour_data, (c) => c.convertedValue)?.convertedValue || 0,
                low: lodash.minBy(last_hour_data, (c) => c.convertedValue)?.convertedValue || 0,
                sum: lodash.sumBy(last_hour_data, (c) => Number(madrugada_check(c))),
            }
        };

        /// append to result dictionary calulated results
        measures_results[measure.Sensor.code] = {
            ...measure_results,
            ...day_quarters_results,
            ...last_hour_results,
        };
    }

    return res.status(200).json(measures_results);
}
