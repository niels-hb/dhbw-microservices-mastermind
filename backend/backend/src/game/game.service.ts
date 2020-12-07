import { Injectable, HttpException, HttpStatus, forwardRef, Inject } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { GameEntity } from './game.entity';
import { GameData, GameConfigDto, PinDto, RatingDto, RoundDto } from './dto';
import { validate } from 'class-validator';
import { UserService } from '../user/user.service';

@Injectable()
export class GameService {
  constructor(
    @InjectRepository(GameEntity)
    private readonly gameRepository: Repository<GameEntity>,
    @Inject(forwardRef(() => UserService))
    private readonly userService: UserService
  ) {}

  public async findAll(filter: gameFilter): Promise<GameData[]> {
    const game = await this.gameRepository.find();
    return this.filterGames(filter, this.convert2Dto(game));
  }

  public async findById(id: string): Promise<GameData> {
    try {
      const game = await this.gameRepository.findOne(id);

      if (!game) {
        const errors = {game: 'Could not find the requested game!'};
        throw new HttpException({message: 'Model validation failed', errors}, HttpStatus.BAD_REQUEST);
      }

      return this.buildGameDto(game, true);
    } catch (e) {
      const errors = {game: 'Could not find the requested game!'};
      throw new HttpException({message: 'Model validation failed', errors}, HttpStatus.BAD_REQUEST);
    }
  }

  public async findByUsername(username: string, filter: gameFilter): Promise<GameData[]> {
    const game = await this.gameRepository.find({
      where: {
        username
      }
    });

    return this.filterGames(filter, this.convert2Dto(game));
  }

  public async create(username: string, dto: GameConfigDto, removeSolution: boolean = true): Promise<GameData> {
    const newGame = new GameEntity();
    newGame.username = username;
    newGame.undoUsed = false;
    newGame.config = dto;
    newGame.rounds = [];
    newGame.solution = this.buildSolution(dto);
    newGame.status = 'playing';

    const err = await validate(newGame);
    if (err.length > 0) {
      console.log(err);
      const errors = {game_config: 'Failed to generate GameEntity Model'};
      throw new HttpException({message: 'Model validation failed', errors}, HttpStatus.BAD_REQUEST);
    } else {
      const savedGame = await this.gameRepository.save(newGame);
      this.userService.setLastGame(username, savedGame.id.toString());
      return this.buildGameDto(savedGame, removeSolution);
    }
  }

  public async createBasedOn(username, gameID) : Promise<GameData> {
    try {
      const game = await this.gameRepository.findOne(gameID);

      if (!game) {
        const errors = {game: 'Could not find the requested game!'};
        throw new HttpException({message: 'Model validation failed', errors}, HttpStatus.BAD_REQUEST);
      }

      const base = this.buildGameDto(game, false);
      const newGame = new GameEntity();
      newGame.username = username;
      newGame.refernceGameId = gameID;
      newGame.undoUsed = false;
      newGame.config = base.config;
      newGame.rounds = [];
      newGame.solution = base.solution;
      newGame.status = 'playing';

      const err = await validate(newGame);
      if (err.length > 0) {
        console.log(err);
        const errors = {game_config: 'Failed to generate GameEntity Model based on Game ' + gameID};
        throw new HttpException({message: 'Model validation failed', errors}, HttpStatus.BAD_REQUEST);
      } else {
        const savedGame = await this.gameRepository.save(newGame);
        return this.buildGameDto(savedGame, true);
      }
    } catch (e) {
      const errors = {game: 'Could not find the requested game!'};
      throw new HttpException({message: 'Model validation failed', errors}, HttpStatus.BAD_REQUEST);
    }
  }

  public async seed(amount: number): Promise<GameData[]> {
    const games = [];
    const users = await this.userService.findAll(undefined, undefined, undefined);

    if (users.length == 0) {
      const errors = {game: 'There are no users available in the Database!'};
      throw new HttpException({message: 'Model validation failed', errors}, HttpStatus.BAD_REQUEST);
    }

    for (let i = 0; i < amount; i++) {
      const username = users[Math.floor(Math.random() * users.length)].username;
      const pins = this.randomIntFromInterval(4, 8);

      try {
        const game = await this.create(username, {
          pins,
          allowDuplicateColors: this.randomBool(),
          allowEmptyFields: this.randomBool(),
          gameColors: this.buildGameColors(this.randomIntFromInterval(6, 8)),
          maxRounds: this.randomIntFromInterval(1, 12),
          mode: 'Mode.online_computer',
          player2: null
        }, false);

        for (let i = 0; i < game.config.maxRounds; i++) {
          let round;

          if (this.randomIntFromInterval(1, 6) == 4 && game.solution) {
            round = await this.createRound(username, game.id, game.solution); // force win
          } else {
            round = await this.createRound(username, game.id, this.buildSolution(game.config));
          }

          game.rounds.push(round);
          if (round.rating.exactMatch == game.config.pins) {
            break;
          }
        }

        game.rounds = game.rounds.reverse();
        delete game.solution;
        games.push(game);
      } catch (e) {
        console.log(e);
      }
      
      await this.timer(10);
    }

    return games;
  }

  private randomIntFromInterval(min, max) {
    return Math.floor(Math.random() * (max - min + 1) + min);
  }

  private randomBool(): boolean {
    return this.randomIntFromInterval(0, 1) == 0;
  }

  private timer(ms) { return new Promise(res => setTimeout(res, ms)); }

  public async createRound(username: string, id: string, guess: PinDto[], save: boolean = true): Promise<RoundDto> {
    let toUpdate;
  
    try {
      toUpdate = await this.gameRepository.findOne(id);
    } catch (e) {
      const errors = { message: 'Could not parse the gameID' };
      throw new HttpException({errors}, 400);
    }

    if (toUpdate == undefined || toUpdate.username != username) {
      const errors = { message: 'Could not find the game you want to modify' };
      throw new HttpException({errors}, 404);
    }

    if (!guess) {
      const errors = { message: 'The guess could not be parsed' };
      throw new HttpException({errors}, 400);
    }

    if (guess.length != toUpdate.solution.length) {
      const errors = { message: 'The guess length does not match the configured size' };
      throw new HttpException({errors}, 400);
    }

    if (toUpdate.rounds.length == toUpdate.config.maxRounds || toUpdate.status == 'won') {
      const errors = { message: 'The Game is already over! This round wont be saved' };
      throw new HttpException({errors}, 400);
    }
    
    const rating = this.getRatingForColors(toUpdate.config, guess, toUpdate.solution);
    const round = {
      id: toUpdate.rounds.length + 1,
      guess,
      rating
    };
    
    toUpdate.rounds.unshift(round);

    if (rating.exactMatch == toUpdate.config.pins) {
      toUpdate.status = 'won';
    } else if (toUpdate.rounds.length == toUpdate.config.maxRounds) {
      toUpdate.status = 'lose';
    }

    if (save) {
      await this.gameRepository.save(toUpdate);
    }

    return round;
  }

  public async undoRound(username: string, id: string, roundID: number): Promise<String> {
    let toUpdate = await this.gameRepository.findOne(id);
    if (toUpdate == undefined || toUpdate.username != username) {
      const errors = { message: 'Could not find the game you want to modify' };
      throw new HttpException({errors}, 404);
    }
    let index = toUpdate.rounds.findIndex(x => x.id == roundID);

    if (index != -1) {
      toUpdate.undoUsed = true;
      toUpdate.status = 'playing';
      toUpdate.rounds.splice(index, 1);
      await this.gameRepository.save(toUpdate);
      return 'OK';
    } else {
      const errors = { message: 'Could not find the given round in the requested game' };
      throw new HttpException({errors}, 404);
    }
  }

  getRatingForColors(config: GameConfigDto, gameColors: PinDto[], solution: PinDto[]): RatingDto {
    let exactMatch = 0;
    let partMatch = 0;

    let solutionCopy: PinDto[] = [];
    let roundCopy: PinDto[] = [];
    solutionCopy.push(...solution);
    roundCopy.push(...gameColors);

    for (let i = 0; i < roundCopy.length; i++) {
      if (roundCopy[i] != null && solutionCopy[i] != null) {
        if (roundCopy[i].id == solutionCopy[i].id) {
          exactMatch++;
  
          roundCopy[i] = null;
          solutionCopy[i] = null;
        }
      }
    }

    for (let i = 0; i < solutionCopy.length; i++) {
      for (let j = 0; j < roundCopy.length; j++) {
        if (solutionCopy[i] != null && roundCopy[j] != null) {
          if (solutionCopy[i].id == roundCopy[j].id) {
            partMatch++;
  
            solutionCopy[i] = null;
            roundCopy[j] = null;
            break;
          }
        }
      }
    }

    return {
      exactMatch,
      partMatch,
      noMatch: config.pins - exactMatch - partMatch
    };
  }

  private convert2Dto(game: GameEntity[]): GameData[] {
    if (game.length !== 0) {
      const out = [];
      game.forEach(element => {
        out.push(this.buildGameDto(element, true));
      });
      return out;
    } else {
      return [];
    }
  }

  private buildGameDto(game: GameEntity, removeSolution: boolean = false): GameData {
    let obj = {
      id: game.id.toString(),
      refernceGameId: game.refernceGameId,
      username: game.username,
      undoUsed: game.undoUsed,
      config: game.config,
      rounds: game.rounds,
      solution: game.solution,
      status: game.status
    };

    if (removeSolution) {
      // delete obj.solution;
    } 

    return obj;
  }

  private buildGameColors(amount: number): PinDto[] {
    const available: PinDto[] = [{
      id: 1,
      name: 'green',
    },
    {
      id: 2,
      name: 'grey',
    },
    {
      id: 3,
      name: 'red',
    },
    {
      id: 4,
      name: 'yellow',
    },
    {
      id: 5,
      name: 'brown',
    },
    {
      id: 6,
      name: 'cyan',
    },
    {
      id: 7,
      name: 'teal',
    },
    {
      id: 8,
      name: 'pink',
    }];

    const colors = [];
    for (let i = 0; i < amount; i++) {
      let color = available[Math.floor(Math.random() * available.length)];

      while (colors.includes(color)) {
        color = available[Math.floor(Math.random() * available.length)];
      }

      colors.push(color);
    }
    return colors;
  }

  private buildSolution(config: GameConfigDto): PinDto[] {
    let solution: PinDto[] = [];
    let allowedColors: PinDto[] = [];
    
    allowedColors.push(...config.gameColors);

    if (config.allowEmptyFields) {
      allowedColors.push({
        name: 'transparent',
        id: -1
      });
    }

    for (let i = 0; i < config.pins; i++) {
      let gameColor: PinDto;

      do {
        gameColor = allowedColors.sort(() => Math.random() - 0.5)[0];
      } while (!config.allowDuplicateColors &&
          solution.includes(gameColor) &&
          gameColor.name != 'transparent');

      solution[i] = gameColor;
    }

    return solution;
  }

  private filterGames(filter: gameFilter, games: GameData[]): GameData[] {
    const out = [];
    games.forEach(game => {
      let push = true;

      if (filter.pins) {
        if (parseInt(filter.pins.toString()) != game.config.pins) {
          push = false;
        }
      }

      if (filter.gameColors) {
        if (parseInt(filter.gameColors.toString()) != game.config.gameColors.length) {
          push = false;
        }
      }

      if (filter.tries) {
        if (parseInt(filter.tries.toString()) != game.rounds.length) {
          push = false;
        }
      }

      if (filter.allowDuplicateColors) {
        if (filter.allowDuplicateColors.toString() != game.config.allowDuplicateColors.toString()) {
          push = false;
        }
      }

      if (filter.allowEmptyFields) {
        if (filter.allowEmptyFields.toString() != game.config.allowEmptyFields.toString()) {
          push = false;
        }
      }

      if (filter.status == 'complete' && !(game.status == 'won' || game.status == 'lose')) {
        push = false;
      }

      if (filter.status == 'won' && game.status != 'won') {
        push = false;
      }

      if (filter.status == 'lose' && game.status != 'lose') {
        push = false;
      }

      if (filter.status == 'playing' && game.status != 'playing') {
        push = false;
      }

      if (push) {
        out.push(game);
      }
    });
    return out;
  }
}

class gameFilter {
  pins: number;
  gameColors: number;
  tries: number;
  allowDuplicateColors: boolean;
  allowEmptyFields: boolean;
  status: 'won' | 'lose' | 'playing' | 'complete';
}