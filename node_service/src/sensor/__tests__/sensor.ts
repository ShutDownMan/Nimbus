import request from 'supertest'
import { Express } from 'express-serve-static-core'
import { createServer } from '../../server'
import { faker } from '@faker-js/faker';

let server: Express

beforeAll(async () => {
    server = await createServer();
});

describe('GET /Sensors', () => {
    it('should return 202 & valid response', done => {
        request(server)
            .get(`/Sensors`)
            .send({
                take: 10,
            })
            .expect('Content-Type', /json/)
            .expect(202)
            .end((err, res) => {
                if (err) return done(err)
                expect(res.body.error_type).toBeUndefined()
                done()
            });
    });

    it('should return 202 & valid response', done => {
        request(server)
            .get(`/Sensors`)
            .send({
                take: 10,
                page: 0,
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

describe('GET /Sensor', () => {
    it('should return 202 & valid response', done => {
        request(server)
            .get(`/Sensors`)
            .send({
                take: 10,
                page: 0,
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


describe('POST /Sensor', () => {
    it('should return 202 & valid response', done => {
        request(server)
            .post(`/Sensor`)
            .send({
                code: "00",
                sku: "SK000000001",
                lifespan: faker.date.future(),
                manufacturer: {
                    name: faker.company.companyName(),
                    country: "BR",
                },
            })
            .expect('Content-Type', /json/)
            .expect(202)
            .end((err, res) => {
                if (err) return done(err)
                expect(res.body.error_type).toBeUndefined()
                done()
            });
    });

    it('should return 400 & validation error', done => {
        request(server)
            .post(`/Sensor`)
            .send({

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

describe('PATCH /Sensor', () => {
    it('should return 400 & validation error message', done => {
        request(server)
            .patch(`/Sensor`)
            .send({

            })
            .expect('Content-Type', /json/)
            .expect(400)
            .end((err, res) => {
                if (err) return done(err);
                expect(res.body.error_type).toBeDefined();
                done();
            })
    });

    it('should return 202 & the patched sensor', done => {
        request(server)
            .patch(`/Sensor`)
            .send({
                code: "00",
                sku: "SK111111110"
            })
            .expect('Content-Type', /json/)
            .expect(202)
            .end((err, res) => {
                if (err) return done(err);
                expect(res.body.code).toBeDefined();
                done();
            })
    });
});

describe('DELETE /Sensor', () => {
    it('should return 202 & DELETE Sensor & valid response', done => {
        request(server)
            .delete(`/Sensor`)
            .send({
                code: "00",
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