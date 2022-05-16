import { NextFunction, Request, Response } from "express";
import { Prisma } from '@prisma/client'
import PrismaGlobal from "../prisma";

export async function StationHandler(req: Request, res: Response, next: NextFunction): Promise<any> {
    console.debug("Handling Stations");
    console.debug(req.body);

    const prisma = PrismaGlobal.getInstance().prisma;

    /// for each station
    for (let kv_station of Object.entries(req.body)) {
        /// get station code and station list
        let stationCode: string = kv_station[0].padStart(12, "0")
        let sensors: any = kv_station[1]

        /// prepare station for insertion if needed
        let stationNumericCode: number = Number("0x" + stationCode)
        console.debug(`running through station "${stationCode}"`);
        let stationData: Prisma.StationCreateInput = {
            code: stationNumericCode
        };

        /// for each sensor in the station
        for (let kv_sensor of Object.entries(sensors)) {
            /// get sensor code and measurement units list
            let sensorCode: string = kv_sensor[0].padStart(2, "0")
            let measurementUnits: any = kv_sensor[1]

            /// prepare sensor for insertion if needed
            let sensorNumericCode: number = Number("0x" + sensorCode)
            console.debug(`running through sensor "${sensorCode}"`);
            let sensorData: Prisma.SensorCreateInput = {
                code: sensorNumericCode,
            };

            /// for each measurement unit in the sensor
            for (let kv_measurementUnit of Object.entries(measurementUnits)) {
                /// get sensor code and measurement units list
                let measurementUnitCode: string = kv_measurementUnit[0].padStart(2, "0")
                let measuredValues: any = kv_measurementUnit[1]

                let measurementUnitNumericCode: number = Number("0x" + measurementUnitCode)
                console.debug(`running through measurementUnit "${measurementUnitCode}"`);

                let measurementUnitData: Prisma.MeasurementUnitCreateInput = {
                    code: measurementUnitNumericCode,
                };

                let measureDataCode = Number("0x" + stationCode + sensorCode + measurementUnitCode);

                console.debug(measureDataCode)

                /// for each measured value
                for (let measuredValue of measuredValues) {
                    // measurementUnit.insertMeasuredValue(measuredValue);
                    let timestamp: number = Number(measuredValue["timestamp"]) * 1000;
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
                        await prisma.measuredData.create({
                            data: measuredData
                        });
                    } catch (error: any) {
                        console.debug(error);
                        return res.status(403).json({ message: "Could not insert measured data" });                        
                    }
                }
            }
        }
    }

    return res.status(200).json({ message: "stations data was added sucessfully" });
}