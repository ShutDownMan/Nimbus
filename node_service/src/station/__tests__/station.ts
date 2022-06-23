import request from 'supertest'
import { Express } from 'express-serve-static-core'
import { createServer } from '../../server'
import { faker } from '@faker-js/faker';

let server: Express

beforeAll(async () => {
    server = await createServer();
});

describe('POST /station', () => {
    it('should return 202 & valid response', done => {
        request(server)
            .post(`/station`)
            .send({
                "afa44ec40a24": {
                    "07": {
                        "0d": [
                            {
                                timestamp: 1655058542,
                                value: -90.5
                            }
                        ]
                    }
                }
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
            .post(`/station`)
            .send({
                "test": "error"
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

describe('POST /station/metadata', () => {
    it('should return 202 & valid response', done => {
        request(server)
            .patch(`/station/metadata`)
            .send({
                "code": "afa44ec40a24",
                "description": faker.lorem.sentence(),
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
            .patch(`/station/metadata`)
            .send({
                "test": "error"
            })
            .expect('Content-Type', /json/)
            .expect(400)
            .end((err, res) => {
                if (err) return done(err)

                expect(res.body.error_type).toBeDefined()

                done()
            });
    });

    it('should return 400 & code not found', done => {
        request(server)
            .patch(`/station/metadata`)
            .send({
                "code": "invalid"
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

describe('DELETE /station', () => {
    it('should return 202 & valid response', done => {
        request(server)
            .delete(`/station`)
            .send({
                "code": "afa44ec40a24"
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
