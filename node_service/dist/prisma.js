"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const client_1 = require("@prisma/client");
class PrismaGlobal {
    constructor() {
        this._prisma = new client_1.PrismaClient({
            log: ['query'],
        });
    }
    static getInstance() {
        if (this._instance) {
            return this._instance;
        }
        this._instance = new PrismaGlobal();
        return this._instance;
    }
    get prisma() {
        return this._prisma;
    }
}
exports.default = PrismaGlobal;
