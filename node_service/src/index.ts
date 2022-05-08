import express, { Express, Request, Response } from 'express';
import dotenv from 'dotenv';
import { body, validationResult } from 'express-validator';
import { getStationsData } from './Station/StationDAO';
import { Pool } from 'node-postgres';

dotenv.config();

const app: Express = express();
const port = process.env.PORT;

app.use(express.json());

const nimbusDB = new Pool()

app.listen(port, () => {
	console.log(`⚡️[server]: Server is running at http://localhost:${port}`);
});

app.get('/', (req: Request, res: Response) => {
	res.send('Express + TypeScript Server');
});

app.post(
	'/Station',
	(req: Request, res: Response) => {
		let stations: Station[] = getStationsData(req.body);

		// console.debug(req.body);
		console.debug(stations);

		res.json({ message: "stations data was added sucessfully" });
	}
);

