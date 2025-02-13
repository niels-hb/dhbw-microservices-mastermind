import { NestFactory } from '@nestjs/core';
import { ApplicationModule } from './app.module';
import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';
import { Request, Response, NextFunction } from 'express';
import pack from '../package.json';
import { env } from './shared/env';

async function bootstrap(): Promise<void> {
  const appOptions = { cors: true };
  const app = await NestFactory.create(ApplicationModule, appOptions);
  app.use((req: Request, res: Response, next: NextFunction) => {
    res.header('x-powered-by', 'mastermind by derbl4ck');
    next();
  });
  app.setGlobalPrefix('api');

  if (env.swagger.enabled) {
    const options = new DocumentBuilder()
    .setTitle(pack.name)
    .setDescription(pack.description)
    .setVersion(pack.version)
    .setBasePath('api')
    .addBearerAuth()
    .build();
    const document = SwaggerModule.createDocument(app, options);
    SwaggerModule.setup(env.swagger.route, app, document);
  }

  await app.listen(env.app.port);
}

bootstrap();
