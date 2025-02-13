import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { DeleteResult, Repository, FindManyOptions } from 'typeorm';
import { validate } from 'class-validator';
import { HttpException } from '@nestjs/common/exceptions/http.exception';
import { HttpStatus } from '@nestjs/common';
import * as argon2 from 'argon2';
import jwt from 'jsonwebtoken';
import { UserEntity } from './user.entity';
import { CreateUserDto, LoginUserDto, UpdateUserDto, UserDto } from './dto';
import { env } from '../shared/env';
import * as faker from 'faker';
import { GameData } from '../game/dto';
import { GameEntity } from '../game/game.entity';

@Injectable()
export class UserService {
  constructor(
    @InjectRepository(UserEntity)
    private readonly userRepository: Repository<UserEntity>,
    @InjectRepository(GameEntity)
    private readonly gameRepository: Repository<GameEntity>,
  ) {}

  public async findGameById(id: string): Promise<GameData> {
    try {
      const game = await this.gameRepository.findOne(id);

      if (!game) {
        return null;
      }

      return {
        id: game.id.toString(),
        refernceGameId: game.refernceGameId,
        username: game.username,
        undoUsed: game.undoUsed,
        config: game.config,
        rounds: game.rounds,
        solution: game.solution,
        status: game.status
      };
    } catch (e) {
      return null;
    }
  }

  public async findAll(search: string, take: number, skip: number): Promise<UserDto[]> {
    let options: FindManyOptions<UserEntity> = {};

    if (search) {
      options.where = {
        username: new RegExp(`.*${search}.*`, 'gi')
      };
    }

    if (take) {
      options.take = parseInt(take.toString());
    }

    if (skip) {
      options.skip = parseInt(skip.toString());
    }
    
    try {
      return this.convert2Dto(await this.userRepository.find(options));
    } catch (e) {
      const errors = { db_driver: e };
      throw new HttpException({ message: 'DB statement failed', errors }, HttpStatus.UNPROCESSABLE_ENTITY);
    }
  }

  public async findOne({email, password}: LoginUserDto): Promise<UserEntity> {
    if (!RegExp('[A-Za-z0-9_\\-!$%&§@*+]').test(password)) {
      const errors = { password: 'Password does not match the Pattern [A-Za-z0-9\_-!\$\%\&§@*+]\{8,32\}.' };
      throw new HttpException({ message: 'Input data validation failed', errors }, HttpStatus.BAD_REQUEST);
    }

    const user = await this.userRepository.findOne({email});
    if (!user) {
      return undefined;
    }

    try {
      if (await argon2.verify(user.password, password)) {
        return user;
      }
    } catch (e) {
      const errors = { password: 'Could not verify your password. Please contact the SysAdmin!' };
      throw new HttpException({ message: 'Login failed', errors }, HttpStatus.BAD_REQUEST);
    }

    return undefined;
  }

  public async seed(amount: number): Promise<UserDto[]> {
    const users = [];
    
    for (let i = 0; i < amount; i++) {
      let username = faker.internet.userName();

      while (!(username.length >= 4 && username.length <= 16 && RegExp('[A-Za-z0-9\_-]').test(username))) {
        username = faker.internet.userName();
      }

      try {
        users.push(await this.create({
          email: faker.internet.email(),
          password: 'password',
          username
        }));
      } catch (e) {}
      
      await this.timer(10);
    }

    return users;
  }

  private timer(ms) { return new Promise(res => setTimeout(res, ms)); }

  public async create(dto: CreateUserDto): Promise<UserDto> {
    if (!RegExp('[A-Za-z0-9\_-]').test(dto.username)) {
      const errors = { username: 'Username does not match the Pattern [A-Za-z0-9\_-]\{4,16\}.' };
      throw new HttpException({ message: 'Input data validation failed', errors }, HttpStatus.BAD_REQUEST);
    }

    if (!RegExp('[A-Za-z0-9_\\-!$%&§@*+]').test(dto.password)) {
      const errors = { password: 'Password does not match the Pattern [A-Za-z0-9\_-!\$\%\&§@*+]\{8,32\}.' };
      throw new HttpException({ message: 'Input data validation failed', errors }, HttpStatus.BAD_REQUEST);
    }

    // check uniqueness of username/email
    const { username, email, password } = dto;
    const user = await this.userRepository.find({
      where: {
        $or: [
            { username },
            { email },
          ],
      },
    });

    if (user.length !== 0) {
      const errors = { uniqueness: 'Username or email is already taken.' };
      throw new HttpException({ message: 'Input data validation failed', errors }, HttpStatus.BAD_REQUEST);
    }

    // create new user
    const newUser = new UserEntity();
    newUser.username = username;
    newUser.email = email;
    newUser.password = password;
    newUser.followerCount = 0;
    newUser.currentGame = null;

    const errors = await validate(newUser);
    if (errors.length > 0) {
      const errors = {username: 'Userinput is not valid.'};
      throw new HttpException({message: 'Input data validation failed', errors}, HttpStatus.BAD_REQUEST);

    } else {
      const savedUser = await this.userRepository.save(newUser);
      return this.buildUserDto(savedUser);
    }
  }

  public async changeFollow(username: string, usernameB: string, operation: 'add' | 'remove'): Promise<UserDto> {
    if (username == usernameB) {
      const errors = { message: 'you cant (un)follow yourself' };
      throw new HttpException({errors}, 400);
    }

    let toUpdate = await this.userRepository.findOne({ username });
    let toUpdateB = await this.userRepository.findOne({ username: usernameB });
    if (toUpdate == undefined || toUpdateB == undefined) {
      const errors = { message: 'The person you want to (un)follow does not exist!' };
      throw new HttpException({errors}, 404);
    }

    if (toUpdate.following == undefined) {
      toUpdate.following = [];
    }
    if (toUpdateB.followerCount == undefined) {
      toUpdateB.followerCount = 0;
    }
    const isFriend = toUpdate.following.findIndex(x => x.username == toUpdateB.username);

    if (operation == 'add') {
      if (isFriend != -1) {
        return this.buildUserDto(toUpdate);
      } else {
        toUpdateB.followerCount++;
        toUpdate.following.push({
          status: new Date().toLocaleString('de-DE', { timeZone: 'UTC' }),
          username: toUpdateB.username
        });
        await this.userRepository.save(toUpdateB);
        return this.buildUserDto(await this.userRepository.save(toUpdate));
      }
    } else {
      if (isFriend == -1) {
        return this.buildUserDto(toUpdate);
      } else {
        if (toUpdateB.followerCount > 0) {
          toUpdateB.followerCount--;
        }
        toUpdate.following.splice(isFriend, 1);
        await this.userRepository.save(toUpdateB);
        return this.buildUserDto(await this.userRepository.save(toUpdate));
      }
    }
  }

  public async update(username: string, dto: UpdateUserDto): Promise<UserDto> {
    let toUpdate = await this.userRepository.findOne({ username });
    if (toUpdate == undefined) {
      const errors = { message: 'The person you want to edit does not exist!' };
      throw new HttpException({errors}, 404);
    }
    toUpdate.bio = dto.bio ? dto.bio : null;
    toUpdate.email = dto.email;
    if (dto.password != null) {
      toUpdate.password = await argon2.hash(dto.password);
    }
    return this.buildUserDto(await this.userRepository.save(toUpdate));
  }

  public async setLastGame(username: string, gameID: string): Promise<UserDto> {
    let toUpdate = await this.userRepository.findOne({ username });
    if (toUpdate == undefined) {
      const errors = { message: 'The person you want to edit does not exist!' };
      throw new HttpException({errors}, 404);
    }
    toUpdate.currentGame = gameID;
    return this.buildUserDto(await this.userRepository.save(toUpdate));
  }

  public async delete(username: string): Promise<DeleteResult> {
    // TODO: delete all follow user fields
    return await this.userRepository.delete({ username });
  }

  public async findById(id: string): Promise<UserDto> {
    const user = await this.userRepository.findOne(id);

    if (!user) {
      return null;
    }

    return this.buildUserDto(user);
  }

  public async findByUsername(username: string, token: boolean = false): Promise<UserDto> {
    const user = await this.userRepository.findOne({ username });

    if (!user) {
      const errors = { User: 'not found' };
      throw new HttpException({errors}, 401);
    }

    return this.buildUserDto(user, token);
  }

  public generateJWT(user: any): any {
    const today = new Date();
    const exp = new Date(today);
    exp.setDate(today.getDate() + 60);

    return jwt.sign({
      id: user.id,
      username: user.username,
      email: user.email,
      exp: exp.getTime() / 1000,
    }, env.app.secret);
  }

  private async buildUserDto(user: UserEntity, token: boolean = false): Promise<UserDto> {
    const userDto = {
      id: user.id,
      username: user.username,
      email: user.email,
      bio: user.bio ? user.bio : null,
      token: this.generateJWT(user),
      following: user.following ? user.following : [],
      followerCount: user.followerCount ? user.followerCount : 0,
      currentGame: null
    };

    if (!token) {
      delete userDto.token;
    }

    userDto.currentGame = user.currentGame ? await this.findGameById(user.currentGame) : null;

    if (!(userDto.currentGame && userDto.currentGame.status == 'playing')) {
      userDto.currentGame = null;
    }

    return userDto;
  }

  private async convert2Dto(users: UserEntity[]): Promise<UserDto[]> {
    if (users.length !== 0) {
      const out = [];
      await this.asyncForEach(users, async (user) => {
        out.push(await this.buildUserDto(user, false));
      });
      return out;
    } else {
      return [];
    }
  }

  private async asyncForEach(array, callback) {
    for (let index = 0; index < array.length; index++) {
      await callback(array[index], index, array);
    }
  }
}
