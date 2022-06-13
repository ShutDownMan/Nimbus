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
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const supertest_1 = __importDefault(require("supertest"));
const server_1 = require("../../server");
const pg_1 = require("pg");
let server;
beforeAll(() => __awaiter(void 0, void 0, void 0, function* () {
    const nimbusDB = new pg_1.Pool({
        idleTimeoutMillis: 30000,
        connectionTimeoutMillis: 2000,
    });
    server = yield (0, server_1.createServer)();
}));
describe('POST /equation', () => {
    it('should return 200 & valid response', done => {
        (0, supertest_1.default)(server)
            .post(`/equation`)
            .send({
            equation: "20.25 * raw - 8.1",
            description: "teste",
        })
            .expect('Content-Type', /json/)
            .expect(200)
            .end((err, res) => {
            if (err)
                return done(err);
            expect(res.body.type).toBeUndefined();
            done();
        });
    });
    it('should return 403 & sensor and measurement unit not found', done => {
        (0, supertest_1.default)(server)
            .post(`/equation`)
            .send({
            equation: "20.25 * raw - 8.1",
            description: "teste",
            sensor: "ff",
            measurementUnit: "ff"
        })
            .expect('Content-Type', /json/)
            .expect(403)
            .end((err, res) => {
            if (err)
                return done(err);
            expect(res.body.type).toBeDefined();
            done();
        });
    });
});
