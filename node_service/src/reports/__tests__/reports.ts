import request from 'supertest'
import { Express } from 'express-serve-static-core'
import { createServer } from '../../server'
import { faker } from '@faker-js/faker';

let server: Express

beforeAll(async () => {
    server = await createServer();

    /// insert dummy station
    request(server)
        .post(`/station`)
        .send({
            code: "00",
            name: faker.lorem.word(),
        });
});

afterAll(async () => {
    /// delete dummy station
    request(server)
        .delete(`/station`)
        .send({
            code: "00",
        });
});

describe('GET /station/reports/today', () => {
    it('should return 202 & valid response', done => {
        request(server)
            .get(`/station/reports/today`)
            .send({
                station: "00",
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