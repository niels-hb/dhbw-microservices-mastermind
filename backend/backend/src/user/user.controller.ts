import { Get, Post, Body, Put, Delete, Controller, UsePipes, Param, Query } from '@nestjs/common';
import { UserService } from './user.service';
import { CreateUserDto, UpdateUserDto, LoginUserDto, UserDto } from './dto';
import { HttpException } from '@nestjs/common/exceptions/http.exception';
import { User } from './user.decorator';
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
import { LoginBodyDto } from './dto/login-body.dto';
import { CreateUserBodyDto } from './dto/create-user-body.dto';
import { DeleteResult } from 'typeorm';
import { UpdateUserBodyDto } from './dto/update-user-body.dto';

@ApiBearerAuth()
@ApiTags('user')
@Controller()
export class UserController {

  constructor(private readonly userService: UserService) {}

  @ApiOperation({ description: 'Returns the currently logged in user' })
  @ApiResponse({ status: 200, description: 'Returns data of the currently logged in user', type: UserDto })
  @Get('users/me')
  public async findMe(@User('username') username: string): Promise<UserDto> {
    return await this.userService.findByUsername(username);
  }

  @ApiOperation({ description: 'Updates the currently logged in user' })
  @ApiBody({ description: 'user', required: true, type: UpdateUserBodyDto})
  @ApiResponse({ status: 200, description: 'Returns data of the currently logged in user', type: UserDto })
  @UsePipes(new ValidationPipe())
  @Put('users/me')
  public async update(@User('username') username: string, @Body('user') userData: UpdateUserDto): Promise<UserDto> {
    return await this.userService.update(username, userData);
  }

  @ApiOperation({ description: 'Deletes the currently logged in user' })
  @ApiResponse({ status: 200, description: 'Returns the result of the deletion', type: DeleteResult })
  @Delete('users/me')
  public async delete(@User('username') username: string): Promise<DeleteResult> {
    return await this.userService.delete(username);
  }

  @ApiOperation({ description: 'Returns all users' })
  @ApiResponse({ status: 200, description: 'Return all users.', type: UserDto, isArray: true })
  @ApiQuery({ name: 'searchterm', type: String, required: false })
  @ApiQuery({ name: 'take', type: Number, required: false })
  @ApiQuery({ name: 'skip', type: Number, required: false })
  @Get('users')
  public async findAll(@Query('searchterm') searchterm: string, @Query('take') take: number, @Query('skip') skip: number): Promise<UserDto[]> {
    return await this.userService.findAll(searchterm, take, skip);
  }

  @ApiOperation({ description: 'Returns a given user' })
  @ApiResponse({ status: 200, description: 'Returns data of the requested user', type: UserDto })
  @ApiParam({ name: 'username' })
  @Get('users/:username')
  public async findUser(@Param() params: any): Promise<UserDto> {
    return await this.userService.findByUsername(params.username);
  }

  @ApiOperation({ description: 'The current logged in user follows :username' })
  @ApiResponse({ status: 200, description: 'Returns data of the updated user', type: UserDto })
  @ApiParam({ name: 'username' })
  @Post('users/:username/follow')
  public async follow(@Param() params: any, @User('username') username: string): Promise<UserDto> {
    return await this.userService.changeFollow(username, params.username, 'add');
  }

  @ApiOperation({ description: 'The current logged in user unfollows :username' })
  @ApiResponse({ status: 200, description: 'Returns data of the updated user', type: UserDto })
  @ApiParam({ name: 'username' })
  @Delete('users/:username/unfollow')
  public async unfollow(@Param() params: any, @User('username') username: string): Promise<UserDto> {
    return await this.userService.changeFollow(username, params.username, 'remove');
  }

  @ApiOperation({ description: 'adds a user' })
  @ApiResponse({ status: 200, description: 'Returns data of the created user', type: UserDto })
  @ApiBody({ description: 'user', required: true, type: CreateUserBodyDto})
  @UsePipes(new ValidationPipe())
  @Post('users')
  public async create(@Body('user') userData: CreateUserDto): Promise<UserDto> {
    return this.userService.create(userData);
  }

  @ApiOperation({ description: 'adds some new FakeData' })
  @ApiResponse({ status: 200, description: 'Returns data of the faked users', type: UserDto, isArray: true })
  @ApiQuery({ name: 'amount', type: Number, required: false })
  @Post('users/seed-data')
  public async seed(@Query('amount') amount: number): Promise<UserDto[]> {
    return this.userService.seed(amount);
  }

  @ApiOperation({ description: 'generates a jwt token / logges in a user' })
  @ApiResponse({ status: 200, description: 'Returns data of the logged in user', type: UserDto })
  @ApiBody({ description: 'user', required: true, type: LoginBodyDto})
  @UsePipes(new ValidationPipe())
  @Post('users/login')
  public async login(@Body('user') loginUserDto: LoginUserDto): Promise<UserDto> {
    const _user = await this.userService.findOne(loginUserDto);

    const errors = { User: 'Combination of email/password was not found!' };
    if (!_user) {
      throw new HttpException({errors}, 401);
    }

    const token = await this.userService.generateJWT(_user);
    const {email, username, bio, following, currentGame, followerCount} = _user;
    let user = {
      email,
      token,
      username,
      bio,
      following,
      currentGame: null,
      followerCount
    };

    user.currentGame = currentGame ? await this.userService.findGameById(currentGame) : null;

    if (!(user.currentGame && user.currentGame.status == 'playing')) {
      user.currentGame = null;
    }

    return user;
  }
}
