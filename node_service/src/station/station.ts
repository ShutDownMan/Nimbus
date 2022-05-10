import { Request, Response } from "express";
import { Prisma } from '@prisma/client'
import PrismaGlobal from "../prisma";

export async function StationHandler(req: Request, res: Response): Promise<Response<any, Record<string, any>>> {
    console.debug("Handling Stations");
    // console.debug(req.body);

    const prisma = PrismaGlobal.getInstance().prisma;

    for (let kv_station of Object.entries(req.body)) {
        // databaseDAO.insertStation(station);
        let stationCode: string = kv_station[0]
        let stations: any = kv_station[1]

        console.debug(`running through station "${stationCode}"`);

        let stationData: Prisma.StationCreateInput = {
            code: Number("0x" + stationCode)
        };

        for (let kv_sensor of Object.entries(stations)) {
            // station.insertSensor(sensor);
            let sensorCode: string = kv_sensor[0]
            let sensors: any = kv_sensor[1]

            console.debug(`running through sensor "${sensorCode}"`);

            let sensorData: Prisma.SensorCreateInput = {
                code: Number("0x" + sensorCode),
            };

            for (let kv_measurementUnit of Object.entries(sensors)) {
                // sensor.insertMeasurementUnit(measurementUnit);
                let measurementUnitCode: string = kv_measurementUnit[0]
                let measurementUnits: any = kv_measurementUnit[1]

                console.debug(`running through measurementUnit "${measurementUnitCode}"`);

                let measurementUnitData: Prisma.MeasurementUnitCreateInput = {
                    code: Number("0x" + measurementUnitCode)
                };

                let measureDataCode = Number("0x" + stationCode + sensorCode + measurementUnitCode);

                // console.debug(measureDataCode)

                for (let measuredValue of measurementUnits) {
                    // measurementUnit.insertMeasuredValue(measuredValue);
                    let timestamp: string = measuredValue["timestamp"]
                    let value: string = measuredValue["value"]

                    console.debug(`inserting value "${value} from ${timestamp}"`);

                    let station_Sensor_MeasurementUnitData: Prisma.Station_Sensor_MeasurementUnitCreateInput = {
                        code: measureDataCode,
                        MeasurementUnit: {
                            connectOrCreate: {
                                create: measurementUnitData,
                                where: {
                                    code: measurementUnitData.code
                                }
                            }
                        },
                        Sensor: {
                            connectOrCreate: {
                                create: sensorData,
                                where: {
                                    code: sensorData.code
                                }
                            }
                        },
                        Station: {
                            connectOrCreate: {
                                create: stationData,
                                where: {
                                    code: stationData.code
                                }
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

                    prisma.measuredData.create({
                        data: measuredData
                    }).catch((reason: any) => {
                        console.debug(reason);
                        // return res.json({ message: "Could not insert measured data" });
                    });
                }
            }
        }
    }

    return res.json({ message: "stations data was added sucessfully" });
}