import { IsNotEmpty } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';
import { CreateUserDto } from '.';

export class CreateUserBodyDto {

  @ApiProperty()
  @IsNotEmpty()
  public readonly user: CreateUserDto;
}
