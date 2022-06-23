import express, { Express, Request, Response } from 'express';
import { EquationDeleteHandler, EquationInsertHandler } from './equation/equation';
import { MeasureDeleteHandler, MeasureFetchHandler, MeasureInsertHandler, MeasurePatchHandler, MeasuresFetchHandler } from './measure/measure';
import { StationReportTodayFetchHandler } from './reports/reports';
import { SensorDeleteHandler, SensorFetchHandler, SensorInsertHandler, SensorPatchHandler, SensorsFetchHandler } from './sensor/sensor';
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
        '/equation',
        EquationInsertHandler
    );

    app.delete(
        '/equation',
        EquationDeleteHandler
    );

    /// Sensor Endpoints

    app.get(
        '/sensors',
        SensorsFetchHandler
    );

    app.get(
        '/sensor',
        SensorFetchHandler
    );

    app.post(
        '/sensor',
        SensorInsertHandler
    );

    app.patch(
        '/sensor',
        SensorPatchHandler
    );

    app.delete(
        '/sensor',
        SensorDeleteHandler
    );

    /// Measure Endpoints

    app.get(
        '/measures',
        MeasuresFetchHandler
    );

    app.get(
        '/measure',
        MeasureFetchHandler
    );

    app.post(
        '/measure',
        MeasureInsertHandler
    );

    app.patch(
        '/measure',
        MeasurePatchHandler
    );

    app.delete(
        '/measure',
        MeasureDeleteHandler
    );

    /// Report Endpoints

    app.get(
        '/station/reports/today',
        StationReportTodayFetchHandler
    );

    return app;
}