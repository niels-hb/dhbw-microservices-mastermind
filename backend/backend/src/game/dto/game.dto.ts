import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty } from 'class-validator';
import { GameConfigDto, PinDto } from '.';
import { RoundDto } from './round.dto';

export class GameData {
  @ApiProperty()
  public readonly id: string;

  @ApiProperty()
  public readonly refernceGameId: string;

  @ApiProperty()
  @IsNotEmpty()
  public readonly username: string;

  @ApiProperty()
  public readonly status: string;

  @ApiProperty()
  @IsNotEmpty()
  public readonly undoUsed: boolean;

  @ApiProperty()
  @IsNotEmpty()
  public readonly config: GameConfigDto;

  @ApiProperty({
    isArray: true,
    type: PinDto
  })
  @IsNotEmpty()
  public solution: PinDto[];

  @ApiProperty({
    isArray: true,
    type: RoundDto
  })
  public rounds: RoundDto[];
}