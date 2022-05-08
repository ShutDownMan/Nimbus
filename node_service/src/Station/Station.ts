
type MeasuredValue = {
    timestamp: string,
    value: Number
}

type MeasurementUnit = {
    code: string,
    values: MeasuredValue[]
}

type Sensor = {
    code: string,
    measurementUnits: MeasurementUnit[]
}

type Station = {
    code: string,
    sensors: Sensor[]
}