import { Pool } from "node-postgres"

/// transorm any object into an array of Stations
export function getStationsData(obj: any): Station[] {
    return Object.entries(obj)
        .map((keyValuePair) => {
            let key = keyValuePair[0]
            let value = keyValuePair[1]

            return {
                code: typeof key === 'string' ? key : "invalid",
                sensors: getSensorsData(value)
            }
        })
        .filter((station) => {
            return station.code !== "invalid"
        })
}

/// transform any object into array of sensor data
export function getSensorsData(obj: any): Sensor[] {
    return Object.entries(obj)
        .map((keyValuePair) => {
            let key = keyValuePair[0]
            let value = keyValuePair[1]

            return {
                code: typeof key === 'string' ? key : "invalid",
                measurementUnits: getMeasurementUnitsData(value)
            }
        })
        .filter((sensor) => {
            return sensor.code !== "invalid"
        })
}

/// transform any object into an array of MeasurementUnit
export function getMeasurementUnitsData(obj: any): MeasurementUnit[] {
    return Object.entries(obj)
        .map((keyValuePair) => {
            let key = keyValuePair[0]
            let value = keyValuePair[1]

            return {
                code: typeof key === 'string' ? key : "invalid",
                values: getMeasuredValueData(value)
            }
        })
        .filter((measurementUnit) => {
            return measurementUnit.code !== "invalid"
        })
}

/// transform any object into an array of MeasuredValue
export function getMeasuredValueData(obj: any): MeasuredValue[] {
    return (obj as any[])
        .map((arrValue) => {
            return {
                timestamp: typeof arrValue["timestamp"] === 'string' ? arrValue["timestamp"] : "invalid",
                value: typeof arrValue["arrValue"] === 'number' ? arrValue["arrValue"] : 0
            }
        })
        .filter((measurementUnit) => {
            return measurementUnit.timestamp !== "invalid"
        })
}

export async function insertStation(db: Pool, station: Station): Promise<number> {
    let query = `INSERT INTO "station" ("code")  
        VALUES ($1)
        RETURNING *
    `;

    return db.query(query, [station.code])
        .then((res) => {
            console.debug(`station insert sucess: ${res}`)
            return res.rows[0].id;
        })
        .catch((res) => {
            console.debug(`station insert error: ${res}`)
            return -1
        });
}