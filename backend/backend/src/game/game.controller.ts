import { Get, Post, Body, Controller, UsePipes, Param, Delete, Query } from '@nestjs/common';
import { GameConfigDto, CreateRoundBodyDto, GameData, RoundDto } from './dto';
import { ValidationPipe } from '../shared/pipes/validation.pipe';

import {
  ApiTags,
  ApiBearerAuth,
  ApiOperation,
  ApiResponse,
  ApiBody,
  ApiParam,
  ApiQuery,
} from '@nestjs/swagger';
import { GameService } from './game.service';
import { User } from '../user/user.decorator';
import { CreateGameBodyDto } from './dto/create-game-body.dto';
import { FollowingDto } from '../user/dto/following.dto';

@ApiBearerAuth()
@ApiTags('game')
@Controller()
export class GameController {

  constructor(private readonly gameService: GameService) {}

  @ApiOperation({ description: 'Adds a new game' })
  @ApiBody({ description: 'game', required: true, type: CreateGameBodyDto})
  @ApiResponse({ status: 200, description: 'Returns the created game entity.', type: GameData })
  @UsePipes(new ValidationPipe())
  @Post('games')
  public async create(@User('username') username: string, @Body('game') gameData: GameConfigDto): Promise<GameData> {
    return this.gameService.create(username, gameData);
  }

  @ApiOperation({ description: 'Returns the last 25 games of my friends' })
  @ApiResponse({ status: 200, description: 'Return all described games.', type: GameData, isArray: true })
  @ApiQuery({ name: 'pins', type: Number, required: false })
  @ApiQuery({ name: 'gameColors', type: Number, required: false })
  @ApiQuery({ name: 'tries', type: Number, required: false })
  @ApiQuery({ name: 'allowDuplicateColors', type: Boolean, required: false })
  @ApiQuery({ name: 'allowEmptyFields', type: Boolean, required: false })
  @Get('games/history/friends')
  public async getFriendsHistory(@User('following') following: FollowingDto[], @Query('pins') pins: number, @Query('gameColors') gameColors: number, @Query('tries') tries: number, @Query('allowDuplicateColors') allowDuplicateColors: boolean, @Query('allowEmptyFields') allowEmptyFields: boolean): Promise<GameData[]> {
    const allGames = [];

    await this.asyncForEach(following, async (user) => {
      const userGames = await this.gameService.findByUsername(user.username, {
        pins,
        gameColors,
        tries,
        allowDuplicateColors,
        allowEmptyFields,
        status: 'complete'
      });
      allGames.push(...userGames);
    });

    return allGames.slice(0, 24);
  }

  @ApiOperation({ description: 'Returns the global game ranking' })
  @ApiResponse({ status: 200, description: 'Return all described games.', type: GameData, isArray: true })
  @ApiQuery({ name: 'pins', type: Number, required: false })
  @ApiQuery({ name: 'gameColors', type: Number, required: false })
  @ApiQuery({ name: 'tries', type: Number, required: false })
  @ApiQuery({ name: 'allowDuplicateColors', type: Boolean, required: false })
  @ApiQuery({ name: 'allowEmptyFields', type: Boolean, required: false })
  @Get('games/ranking/global')
  public async getGlobalRanking(@Query('pins') pins: number, @Query('gameColors') gameColors: number, @Query('tries') tries: number, @Query('allowDuplicateColors') allowDuplicateColors: boolean, @Query('allowEmptyFields') allowEmptyFields: boolean): Promise<GameData[]> {
    return this.gameService.findAll({
      pins,
      gameColors,
      tries,
      allowDuplicateColors,
      allowEmptyFields,
      status: 'won'
    });
  } 

  @ApiOperation({ description: 'Returns the personal game ranking of the current logged in user' })
  @ApiResponse({ status: 200, description: 'Return all described games.', type: GameData, isArray: true })
  @ApiQuery({ name: 'pins', type: Number, required: false })
  @ApiQuery({ name: 'gameColors', type: Number, required: false })
  @ApiQuery({ name: 'tries', type: Number, required: false })
  @ApiQuery({ name: 'allowDuplicateColors', type: Boolean, required: false })
  @ApiQuery({ name: 'allowEmptyFields', type: Boolean, required: false })
  @Get('games/ranking/me')
  public async getMyRanking(@User('username') username: string, @Query('pins') pins: number, @Query('gameColors') gameColors: number, @Query('tries') tries: number, @Query('allowDuplicateColors') allowDuplicateColors: boolean, @Query('allowEmptyFields') allowEmptyFields: boolean): Promise<GameData[]> {
    return this.gameService.findByUsername(username, {
      pins,
      gameColors,
      tries,
      allowDuplicateColors,
      allowEmptyFields,
      status: 'won'
    });
  }

  @ApiOperation({ description: 'Returns the game ranking of logged in users friends' })
  @ApiResponse({ status: 200, description: 'Return all described games.', type: GameData, isArray: true })
  @ApiQuery({ name: 'pins', type: Number, required: false })
  @ApiQuery({ name: 'gameColors', type: Number, required: false })
  @ApiQuery({ name: 'tries', type: Number, required: false })
  @ApiQuery({ name: 'allowDuplicateColors', type: Boolean, required: false })
  @ApiQuery({ name: 'allowEmptyFields', type: Boolean, required: false })
  @Get('games/ranking/friends')
  public async getFriendsRanking(@User('following') following: FollowingDto[], @Query('pins') pins: number, @Query('gameColors') gameColors: number, @Query('tries') tries: number, @Query('allowDuplicateColors') allowDuplicateColors: boolean, @Query('allowEmptyFields') allowEmptyFields: boolean): Promise<GameData[]> {
    const allGames = [];
    await this.asyncForEach(following, async (user) => {
      const userGames = await this.gameService.findByUsername(user.username, {
        pins,
        gameColors,
        tries,
        allowDuplicateColors,
        allowEmptyFields,
        status: 'won'
      });
      allGames.push(...userGames);
    });

    allGames.sort();

    return allGames;
  }

  @ApiOperation({ description: 'Returns all info according to the game' })
  @ApiResponse({ status: 200, description: 'Returns the requested game.', type: GameData })
  @ApiParam({ name: 'gameID' })
  @Get('games/:gameID')
  public async findGame(@Param() params: any): Promise<GameData> {
    return this.gameService.findById(params.gameID);
  }

  @ApiOperation({ description: 'adds some new FakeData' })
  @ApiResponse({ status: 200, description: 'Returns data of the faked games', type: GameData, isArray: true })
  @ApiQuery({ name: 'amount', type: Number, required: false })
  @Post('games/seed-data')
  public async seed(@Query('amount') amount: number): Promise<GameData[]> {
    return this.gameService.seed(amount);
  }

  @ApiOperation({ description: 'Adds a new game, based on a existing one' })
  @ApiResponse({ status: 200, description: 'Returns the created game entity.', type: GameData })
  @ApiParam({ name: 'gameID' })
  @Post('games/:gameID')
  public async createBasedOn(@User('username') username: string, @Param() params: any): Promise<GameData> {
    return this.gameService.createBasedOn(username, params.gameID);
  }
  
  @ApiOperation({ description: 'Adds a round to a game (roundInfo)' })
  @ApiBody({ description: 'guess', required: true, type: CreateRoundBodyDto})
  @ApiResponse({ status: 200, description: 'Returns the rating for the given guess.', type: RoundDto })
  @UsePipes(new ValidationPipe())
  @ApiParam({ name: 'gameID' })
  @Post('games/:gameID/rounds')
  public async createRound(@Param() params: any, @Body() guess: CreateRoundBodyDto, @User('username') username: string): Promise<RoundDto> {
    return this.gameService.createRound(username, params.gameID, guess.guess);
  }

  @ApiOperation({ description: 'Removes the selected round from the given game' })
  @ApiResponse({ status: 200, description: 'Returns the result of the deletion', type: String })
  @ApiParam({ name: 'gameID' })
  @ApiParam({ name: 'roundID', type: Number })
  @Delete('games/:gameID/rounds/:roundID')
  public async undoRound(@Param() params: any, @User('username') username: string): Promise<String> {
    return this.gameService.undoRound(username, params.gameID, params.roundID);
  }

  private async asyncForEach(array, callback) {
    for (let index = 0; index < array.length; index++) {
      await callback(array[index], index, array);
    }
  }
}