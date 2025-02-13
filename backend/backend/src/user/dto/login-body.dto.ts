import { IsNotEmpty } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';
import { LoginUserDto } from './login-user.dto';

export class LoginBodyDto {
  @ApiProperty()
  @IsNotEmpty()
  public readonly user: LoginUserDto;
}
