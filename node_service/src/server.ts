import express, { Express, Request, Response } from 'express';
import { EquationHandler } from './equation/equation';
import { SensorDeleteHandler, SensorFetchHandler, SensorInsertHandler, SensorPatchHandler } from './sensor/sensor';
import { StationHandler } from './station/station';

export async function createServer(): Promise<Express> {

    const app: Express = express();

    app.use(express.json());
    app.use('/ota', express.static('/var/ota'))
    
    app.get('/', (req: Request, res: Response) => {
        res.send('Express + TypeScript Server');
    });
    
    app.post(
        '/Station',
        StationHandler
    );
    
    app.post(
        '/Equation',
        EquationHandler
    );

    app.get(
        '/Sensor',
        SensorFetchHandler
    );

    app.post(
        '/Sensor',
        SensorInsertHandler
    );

    app.patch(
        '/Sensor',
        SensorPatchHandler
    );

    app.delete(
        '/Sensor',
        SensorDeleteHandler
    );

    return app;
}