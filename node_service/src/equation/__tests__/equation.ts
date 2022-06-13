import request from 'supertest'
import { Express } from 'express-serve-static-core'
import { createServer } from '../../server'
import { Pool } from 'pg';

let server: Express

beforeAll(async () => {
    const nimbusDB = new Pool({
        idleTimeoutMillis: 30000,
        connectionTimeoutMillis: 2000,
    });

    server = await createServer();
});

describe('POST /equation', () => {
    it('should return 200 & valid response', done => {
        request(server)
            .post(`/equation`)
            .send({
                equation: "20.25 * raw - 8.1",
                description: "teste",
            })
            .expect('Content-Type', /json/)
            .expect(200)
            .end((err, res) => {
                if (err) return done(err)
                expect(res.body.type).toBeUndefined()
                done()
            });
    });

    it('should return 403 & sensor and measurement unit not found', done => {
        request(server)
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
                if (err) return done(err)
                expect(res.body.type).toBeDefined()
                done()
            });
    });
})