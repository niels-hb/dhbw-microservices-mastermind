import { IsNotEmpty, IsEmail, MinLength, MaxLength } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class CreateUserDto {
  @ApiProperty()
  @IsNotEmpty()
  @MinLength(4)
  @MaxLength(16)
  public readonly username: string;

  @ApiProperty()
  @IsNotEmpty()
  @IsEmail()
  public readonly email: string;

  @ApiProperty()
  @IsNotEmpty()
  @MinLength(8)
  @MaxLength(32)
  public readonly password: string;
}
