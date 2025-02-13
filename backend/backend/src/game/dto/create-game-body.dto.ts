import { IsNotEmpty } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';
import { GameConfigDto } from '.';

export class CreateGameBodyDto {

  @ApiProperty()
  @IsNotEmpty()
  public readonly game: GameConfigDto;
}
