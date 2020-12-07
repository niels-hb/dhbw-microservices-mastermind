import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { UserModule } from './user/user.module';
import { GameModule } from './game/game.module';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UserEntity } from './user/user.entity';
import { env } from './shared/env';

@Module({
  imports: [
    TypeOrmModule.forRoot({
      type: env.db.type as any,
      host: env.db.host,
      port: env.db.port,
      username: env.db.username,
      password: env.db.password,
      database: env.db.database,
      synchronize: env.db.synchronize,
      logging: true,
      logger: 'advanced-console',
      authSource: 'admin',
      loggerLevel: env.db.logging as any,
      entities: ['src/**/**.entity{.ts,.js}'],
    }),
    TypeOrmModule.forFeature([UserEntity]),
    UserModule,
    GameModule,
  ],
  controllers: [
    AppController,
  ],
  providers: [],
})
export class ApplicationModule {}
