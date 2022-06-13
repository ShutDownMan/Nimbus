"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const pg_1 = require("pg");
const server_1 = require("./server");
const port = process.env.PORT || 3000;
const nimbusDB = new pg_1.Pool({
    idleTimeoutMillis: 30000,
    connectionTimeoutMillis: 2000,
});
const server = (0, server_1.createServer)()
    .then(server => {
    server.listen(port, () => {
        console.log(`⚡️[server]: Server is running at http://localhost:${port}`);
    });
});
