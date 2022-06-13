import { Pool } from 'pg';
import { createServer } from './server';

const port = process.env.PORT || 3000;

const nimbusDB = new Pool({
	idleTimeoutMillis: 30000,
	connectionTimeoutMillis: 2000,
});

const server = createServer()
	.then(server => {
		server.listen(port, () => {
			console.log(`⚡️[server]: Server is running at http://localhost:${port}`);
		});
	});