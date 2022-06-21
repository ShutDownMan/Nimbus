import request from 'supertest'
import { Express } from 'express-serve-static-core'
import { createServer } from '../../server'
import { faker } from '@faker-js/faker';

let server: Express

beforeAll(async () => {
    server = await createServer();
});

describe('POST /Measure', () => {
    it('should return 202 & valid response', done => {
        request(server)
            .post(`/Measure`)
            .send({
                code: "00",
                name: "a test name",
                description: "a description",
            })
            .expect('Content-Type', /json/)
            .expect(202)
            .end((err, res) => {
                if (err) return done(err);
                expect(res.body.error_type).toBeUndefined();
                done();
            });
    });

    it('should return 400 & validation error', done => {
        request(server)
            .post(`/Measure`)
            .send({

            })
            .expect('Content-Type', /json/)
            .expect(400)
            .end((err, res) => {
                if (err) return done(err);
                expect(res.body.error_type).toBeDefined();
                done();
            });
    });
});

describe('PATCH /Measure', () => {
    it('should return 400 & validation error message', done => {
        request(server)
            .patch(`/Measure`)
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

    it('should return 202 & the patched measure', done => {
        request(server)
            .patch(`/Measure`)
            .send({
                code: "00",
                description: "test description"
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

describe('DELETE /Measure', () => {
    it('should return 202 & DELETE Measure & valid response', done => {
        request(server)
            .delete(`/Measure`)
            .send({
                code: "00",
            })
            .expect('Content-Type', /json/)
            .expect(202)
            .end((err, res) => {
                if (err) return done(err);
                expect(res.body.error_type).toBeUndefined();
                done();
            });
    });
});