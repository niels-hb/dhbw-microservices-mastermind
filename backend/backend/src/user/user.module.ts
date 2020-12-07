import { MiddlewareConsumer, Module, NestModule, RequestMethod } from '@nestjs/common';
import { UserController } from './user.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UserEntity } from './user.entity';
import { UserService } from './user.service';
import { AuthMiddleware } from './auth.middleware';
import { GameEntity } from '../game/game.entity';

@Module({
  imports: [
    TypeOrmModule.forFeature([UserEntity]),
    TypeOrmModule.forFeature([GameEntity])
  ],
  providers: [UserService],
  controllers: [
    UserController,
  ],
  exports: [UserService],
})
export class UserModule implements NestModule {
  public configure(consumer: MiddlewareConsumer): void {
    consumer
      .apply(AuthMiddleware)
      .forRoutes(
        {path: 'users/me', method: RequestMethod.GET},
        {path: 'users/me', method: RequestMethod.PUT},
        {path: 'users/me', method: RequestMethod.DELETE},
        {path: 'users', method: RequestMethod.GET},
        {path: 'users/:username', method: RequestMethod.GET},
        {path: 'users/:username/follow', method: RequestMethod.POST},
        {path: 'users/:username/unfollow', method: RequestMethod.DELETE});
  }
}
