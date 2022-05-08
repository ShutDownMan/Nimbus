"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.insertStation = exports.getMeasuredValueData = exports.getMeasurementUnitsData = exports.getSensorsData = exports.getStationsData = void 0;
/// transorm any object into an array of Stations
function getStationsData(obj) {
    return Object.entries(obj)
        .map((keyValuePair) => {
        let key = keyValuePair[0];
        let value = keyValuePair[1];
        return {
            code: typeof key === 'string' ? key : "invalid",
            sensors: getSensorsData(value)
        };
    })
        .filter((station) => {
        return station.code !== "invalid";
    });
}
exports.getStationsData = getStationsData;
/// transform any object into array of sensor data
function getSensorsData(obj) {
    return Object.entries(obj)
        .map((keyValuePair) => {
        let key = keyValuePair[0];
        let value = keyValuePair[1];
        return {
            code: typeof key === 'string' ? key : "invalid",
            measurementUnits: getMeasurementUnitsData(value)
        };
    })
        .filter((sensor) => {
        return sensor.code !== "invalid";
    });
}
exports.getSensorsData = getSensorsData;
/// transform any object into an array of MeasurementUnit
function getMeasurementUnitsData(obj) {
    return Object.entries(obj)
        .map((keyValuePair) => {
        let key = keyValuePair[0];
        let value = keyValuePair[1];
        return {
            code: typeof key === 'string' ? key : "invalid",
            values: getMeasuredValueData(value)
        };
    })
        .filter((measurementUnit) => {
        return measurementUnit.code !== "invalid";
    });
}
exports.getMeasurementUnitsData = getMeasurementUnitsData;
/// transform any object into an array of MeasuredValue
function getMeasuredValueData(obj) {
    return obj
        .map((arrValue) => {
        return {
            timestamp: typeof arrValue["timestamp"] === 'string' ? arrValue["timestamp"] : "invalid",
            value: typeof arrValue["arrValue"] === 'number' ? arrValue["arrValue"] : 0
        };
    })
        .filter((measurementUnit) => {
        return measurementUnit.timestamp !== "invalid";
    });
}
exports.getMeasuredValueData = getMeasuredValueData;
function insertStation(db, station) {
    return __awaiter(this, void 0, void 0, function* () {
        let query = `INSERT INTO "station" ("code")  
        VALUES ($1)
        RETURNING *
    `;
        return db.query(query, [station.code])
            .then((res) => {
            console.debug(`station insert sucess: ${res}`);
            return res.rows[0].id;
        })
            .catch((res) => {
            console.debug(`station insert error: ${res}`);
            return -1;
        });
    });
}
exports.insertStation = insertStation;
