import { MiddlewareConsumer, Module, NestModule, RequestMethod } from '@nestjs/common';
import { GameController } from './game.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { GameEntity } from './game.entity';
import { GameService } from './game.service';
import { AuthMiddleware } from '../user/auth.middleware';
import { UserService } from '../user/user.service';
import { UserEntity } from '../user/user.entity';

@Module({
  imports: [TypeOrmModule.forFeature([GameEntity, UserEntity])],
  providers: [GameService, UserService],
  controllers: [
    GameController,
  ],
  exports: [GameService],
})
export class GameModule implements NestModule {
  public configure(consumer: MiddlewareConsumer): void {
    consumer
      .apply(AuthMiddleware)
      .forRoutes(
        {path: 'games', method: RequestMethod.POST},
        {path: 'games/history/friends', method: RequestMethod.GET},
        {path: 'games/ranking/global', method: RequestMethod.GET},
        {path: 'games/ranking/me', method: RequestMethod.GET},
        {path: 'games/ranking/friends', method: RequestMethod.GET},
        {path: 'games/:gameID', method: RequestMethod.GET},
        {path: 'games/:gameID/rounds', method: RequestMethod.POST});
  }
}