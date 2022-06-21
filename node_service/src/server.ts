import express, { Express, Request, Response } from 'express';
import { EquationDeleteHandler, EquationInsertHandler } from './equation/equation';
import { MeasureDeleteHandler, MeasureFetchHandler, MeasureInsertHandler, MeasurePatchHandler } from './measure/measure';
import { SensorDeleteHandler, SensorFetchHandler, SensorInsertHandler, SensorPatchHandler } from './sensor/sensor';
import { StationHandler } from './station/station';

export async function createServer(): Promise<Express> {

    const app: Express = express();

    app.use(express.json());
    app.use('/ota', express.static('/var/ota'))
    
    app.get('/', (req: Request, res: Response) => {
        res.send('Express + TypeScript Server');
    });
    
    /// Station Endpoints

    app.post(
        '/Station',
        StationHandler
    );
    
    /// Equation Endpoints

    app.post(
        '/Equation',
        EquationInsertHandler
    );

    app.delete(
        '/Equation',
        EquationDeleteHandler
    );

    /// Sensor Endpoints

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

    /// Measure Endpoints

    app.get(
        '/Measure',
        MeasureFetchHandler
    );

    app.post(
        '/Measure',
        MeasureInsertHandler
    );

    app.patch(
        '/Measure',
        MeasurePatchHandler
    );

    app.delete(
        '/Measure',
        MeasureDeleteHandler
    );

    return app;
}