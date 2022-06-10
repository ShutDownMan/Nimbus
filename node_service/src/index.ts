import dotenv from 'dotenv';
import express, { Express, Request, Response } from 'express';
import { Pool } from 'pg';
import { StationHandler } from './station/station';

dotenv.config();

const app: Express = express();
const port = process.env.PORT || 3000;

app.use(express.json());
app.use('/ota', express.static('/var/ota'))

const nimbusDB = new Pool({
	idleTimeoutMillis: 30000,
	connectionTimeoutMillis: 2000,
});

app.listen(port, () => {
	console.log(`⚡️[server]: Server is running at http://localhost:${port}`);
});

app.get('/', (req: Request, res: Response) => {
	res.send('Express + TypeScript Server');
});

app.post(
	'/Station',
	StationHandler
);