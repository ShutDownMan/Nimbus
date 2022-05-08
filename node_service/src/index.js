"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const dotenv_1 = __importDefault(require("dotenv"));
const StationDAO_1 = require("./Station/StationDAO");
const node_postgres_1 = require("node-postgres");
dotenv_1.default.config();
const app = (0, express_1.default)();
const port = process.env.PORT;
app.use(express_1.default.json());
const nimbusDB = new node_postgres_1.Pool();
app.listen(port, () => {
    console.log(`⚡️[server]: Server is running at http://localhost:${port}`);
});
app.get('/', (req, res) => {
    res.send('Express + TypeScript Server');
});
app.post('/Station', (req, res) => {
    let stations = (0, StationDAO_1.getStationsData)(req.body);
    // console.debug(req.body);
    console.debug(stations);
    res.json({ message: "stations data was added sucessfully" });
});
