import request from 'supertest'
import { Express } from 'express-serve-static-core'
import { createServer } from '../../server'

let server: Express

beforeAll(async () => {
    server = await createServer();
});

describe('POST /equation', () => {
    it('should return 202 & valid response', done => {
        request(server)
            .post(`/equation`)
            .send({
                equation: "20.25 * raw - 8.1",
                description: "teste",
            })
            .expect('Content-Type', /json/)
            .expect(202)
            .end((err, res) => {
                if (err) return done(err)
                expect(res.body.error_type).toBeUndefined()
                done()
            });
    });

    it('should return 400 & sensor and measurement unit not found', done => {
        request(server)
            .post(`/equation`)
            .send({
                equation: "20.25 * raw - 8.1",
                description: "teste",
                sensor: "ff",
                measurementUnit: "ff"
            })
            .expect('Content-Type', /json/)
            .expect(400)
            .end((err, res) => {
                if (err) return done(err)
                expect(res.body.error_type).toBeDefined()
                done()
            });
    });
});


describe('DELETE /equation', () => {
    it('should return 202 & DELETE equation & valid response', done => {
        request(server)
            .delete(`/equation`)
            .send({
                description: "teste",
            })
            .expect('Content-Type', /json/)
            .expect(202)
            .end((err, res) => {
                if (err) return done(err)
                expect(res.body.error_type).toBeUndefined()
                done()
            });
    });
});