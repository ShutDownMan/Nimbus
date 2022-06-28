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

export async function StationReportTodayFetchHandler(req: Request, res: Response, next: NextFunction): Promise<any> {
    /// get prisma connection
    const prisma = PrismaGlobal.getInstance().prisma;

    console.log("validating input");

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

    console.log("getting all measures from station");

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

    console.log("preprocessing measures");

    /// remove duplicate measures by priority
    let groups_station_measures = lodash.groupBy(station_measures, (c) => c.MeasurementUnit.code);

    console.log("filtering out measures");

    /// filter out the measures not specified
    let sorted_station_measures = lodash
        .map(groups_station_measures, (g) => {
            return g.sort((a, b) => (a.priority && b.priority && a.priority > b.priority) ? 1 : -1);
        });
    let filtered_station_measures = sorted_station_measures.map((g) => {
        return g.pop();
    });

    console.log("separating quarters");

    /// get all measured data from every measure from today
    let now = new Date();
    let today_start = new Date(now.getFullYear(), now.getMonth(), now.getDate(), 0, 0, 0);
    let today_end = new Date(now.getFullYear(), now.getMonth(), now.getDate(), 23, 59, 59);

    console.log("fetching measured data");

    let measures_results: any = {};
    for (let measure of filtered_station_measures) {
        if (!measure) continue;
        let measured_values;
        try {
            measured_values = await prisma.measuredData.findMany({
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

        console.log("processing measured data");
        measured_values = measured_values.filter((m) => m.convertedValue !== null);

        /// calculate results for the whole day
        let measure_results = {
            day: {
                count: measured_values.length,
                mean: lodash.meanBy(measured_values, (c) => c.convertedValue),
                high: lodash.maxBy(measured_values, (c) => c.convertedValue)?.convertedValue,
                low: lodash.minBy(measured_values, (c) => c.convertedValue)?.convertedValue,
                sum: lodash.sumBy(measured_values, (c) => c.convertedValue || 0),
            }
        };

        /// divide them up and calculate the results
        let today_start_milis = today_start.getTime();
        let day_quarters = {
            dawn: [today_start_milis, today_start_milis + (today_end.getTime() - today_start_milis) / 4],
            morning: [today_start_milis + (today_end.getTime() - today_start_milis) / 4, today_start_milis + (today_end.getTime() - today_start_milis) / 2],
            afternoon: [today_start_milis + (today_end.getTime() - today_start_milis) / 2, today_start_milis + (today_end.getTime() - today_start_milis) * 3 / 4],
            dusk: [today_start_milis + (today_end.getTime() - today_start_milis) * 3 / 4, today_start_milis + (today_end.getTime() - today_start_milis)],
        };

        /// check if timestamp is in the first quarter of the day
        const madrugada_check = (c: MeasuredData | null) => {
            return Boolean(c && c.timestamp && c.timestamp.getTime() >= day_quarters.dawn[0] && c.timestamp.getTime() <= day_quarters.dawn[1]);
        };
        const madrugada_values = measured_values.filter(madrugada_check);

        /// check if timestamp is in the second quarter of the day
        const manha_check = (c: MeasuredData | null) => {
            return Boolean(c && c.timestamp && c.timestamp.getTime() >= day_quarters.morning[0] && c.timestamp.getTime() <= day_quarters.morning[1]);
        };
        const manha_values = measured_values.filter(manha_check);

        /// check if timestamp is in the third quarter of the day
        const tarde_check = (c: MeasuredData | null) => {
            return Boolean(c && c.timestamp && c.timestamp.getTime() >= day_quarters.afternoon[0] && c.timestamp.getTime() <= day_quarters.afternoon[1]);
        };
        const tarde_values = measured_values.filter(tarde_check);

        /// check if timestamp is in the fourth quarter of the day
        const noite_check = (c: MeasuredData | null) => {
            return Boolean(c && c.timestamp && c.timestamp.getTime() >= day_quarters.dusk[0] && c.timestamp.getTime() <= day_quarters.dusk[1]);
        };
        const noite_values = measured_values.filter(noite_check);

        console.log("processing quarters");

        /// calculate the results for each quarter
        let day_quarters_results = {
            madrugada: {
                count: madrugada_values.length,
                mean: lodash.meanBy(madrugada_values, (c) => c.convertedValue),
                high: lodash.maxBy(madrugada_values, (c) => c.convertedValue)?.convertedValue,
                low: lodash.minBy(madrugada_values, (c) => c.convertedValue)?.convertedValue,
                sum: lodash.sumBy(madrugada_values, (c) => c.convertedValue || 0),
            },
            manha: {
                count: manha_values.length,
                mean: lodash.meanBy(manha_values, (c) => c.convertedValue),
                high: lodash.maxBy(manha_values, (c) => c.convertedValue)?.convertedValue,
                low: lodash.minBy(manha_values, (c) => c.convertedValue)?.convertedValue,
                sum: lodash.sumBy(manha_values, (c) => c.convertedValue || 0),
            },
            tarde: {
                count: tarde_values.length,
                mean: lodash.meanBy(tarde_values, (c) => c.convertedValue),
                high: lodash.maxBy(tarde_values, (c) => c.convertedValue)?.convertedValue,
                low: lodash.minBy(tarde_values, (c) => c.convertedValue)?.convertedValue,
                sum: lodash.sumBy(tarde_values, (c) => c.convertedValue || 0),
            },
            noite: {
                count: noite_values.length,
                mean: lodash.meanBy(noite_values, (c) => c.convertedValue),
                high: lodash.maxBy(noite_values, (c) => c.convertedValue)?.convertedValue,
                low: lodash.minBy(noite_values, (c) => c.convertedValue)?.convertedValue,
                sum: lodash.sumBy(noite_values, (c) => c.convertedValue || 0),
            },
        };

        console.log("fetching results from last hour");

        /// calculate the results for the last hour
        let last_hour_start = new Date(now.getTime() - (60 * 60 * 1000));
        let last_hour_end = new Date(now.getTime());

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

        console.log("processing results from last hour");

        /// calculate results for the last hour
        let last_hour_results = {
            last_hour: {
                count: last_hour_data.length,
                mean: lodash.meanBy(last_hour_data, (c) => c.convertedValue),
                high: lodash.maxBy(last_hour_data, (c) => c.convertedValue)?.convertedValue,
                low: lodash.minBy(last_hour_data, (c) => c.convertedValue)?.convertedValue,
                sum: lodash.sumBy(last_hour_data, (c) => c.convertedValue || 0),
            }
        };

        console.log("preparing to return results");

        /// append to result dictionary calulated results
        measures_results[measure.MeasurementUnit.name || measure.MeasurementUnit.code] = {
            measure: measure.MeasurementUnit,
            sensor: measure.Sensor,
            ...measure_results,
            ...day_quarters_results,
            ...last_hour_results,
        };
    }

    return res.status(200).json(measures_results);
}
