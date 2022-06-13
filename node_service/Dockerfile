FROM node:18.1.0

WORKDIR /app

COPY package.json .

RUN node --dns-result-order=ipv4first "$(which npm)" i

COPY . .

RUN npx prisma generate

RUN npm run build

# RUN npm run test

EXPOSE 8080

CMD ["npm", "run", "start"]