FROM public.ecr.aws/docker/library/node:18-alpine


WORKDIR /app

COPY package*.json ./
RUN npm ci --include=dev
RUN npm install @fastify/static dotenv
RUN npm install @fastify/cors

COPY . .

COPY ./src/prisma ./prisma

RUN npx prisma generate
RUN npx prisma migrate deploy

RUN mkdir -p ./prisma/images

EXPOSE 3000

CMD ["sh", "-c", "npx prisma migrate deploy && node src/server.js"]


