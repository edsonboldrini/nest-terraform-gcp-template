import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import express, { Express } from 'express';
import { ExpressAdapter } from '@nestjs/platform-express';

const server: Express = express();

async function createNestServer(expressInstance: Express) {
  const adapter = new ExpressAdapter(expressInstance);
  const app = await NestFactory.create(AppModule, adapter);
  app.enableCors();

  // TODO: Change it in future to install the api versioning configs
  // https://docs.nestjs.com/techniques/versioning
  app.setGlobalPrefix('api/v1');
  return app.init();
}

const serverStartPromise = createNestServer(server);

server.use(async (_req, _res, next) => {
  await serverStartPromise;
  next();
});

export { server as main };
