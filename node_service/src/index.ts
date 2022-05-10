import express, { Express, Request, Response } from 'express';
import dotenv from 'dotenv';
import { body, validationResult } from 'express-validator';
import { Pool } from 'pg';
import { PrismaClient, Prisma } from '@prisma/client'

dotenv.config();

const app: Express = express();
const port = process.env.PORT || 3000;

const prisma = new PrismaClient()

app.use(express.json());

const nimbusDB = new Pool({
	idleTimeoutMillis: 30000,
	connectionTimeoutMillis: 2000,
})

// const databaseDAO = new DatabaseDAO(nimbusDB);

// nimbusDB.connect()

app.listen(port, () => {
	console.log(`⚡️[server]: Server is running at http://localhost:${port}`);
});

app.get('/', (req: Request, res: Response) => {
	res.send('Express + TypeScript Server');
});

app.post(
	'/Station',
	(req: Request, res: Response) => {
		// let stations: Station[] = getStationsData(req.body);

		console.debug(req.body);
		// console.debug(stations);

		for (let kv_station of Object.entries(req.body)) {
			// databaseDAO.insertStation(station);
			let stationCode: string = kv_station[0]
			let stationValue: any = kv_station[1]

			let stationData: Prisma.StationCreateInput = {
				code: Number("0x" + stationCode)
			};

			for (let kv_sensor of Object.entries(stationValue)) {
				// station.insertSensor(sensor);
				let sensorCode: string = kv_sensor[0]
				let sensorValue: any = kv_sensor[1]

				let sensorData: Prisma.SensorCreateInput = {
					code: Number("0x" + sensorCode)
				};

				for (let kv_measurementUnit of Object.entries(sensorValue)) {
					// sensor.insertMeasurementUnit(measurementUnit);
					let measurementUnitCode: string = kv_measurementUnit[0]
					let measurementUnitValue: any = kv_measurementUnit[1]

					let measurementUnitData: Prisma.MeasurementUnitCreateInput = {
						code: Number("0x" + measurementUnitCode)
					};

					let measureDataCode = Number("0x" + stationCode + sensorCode + measurementUnitCode);

					console.debug(measureDataCode)

					for (let measuredValue of measurementUnitValue) {
						// measurementUnit.insertMeasuredValue(measuredValue);
						let timestamp: string = measuredValue["timestamp"]
						let value: string = measuredValue["value"]

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
						});
					}
				}
			}
		}

		res.json({ message: "stations data was added sucessfully" });
	}
);