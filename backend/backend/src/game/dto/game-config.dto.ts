import { IsNotEmpty, Min, IsNumber, Max, ArrayMinSize, IsBoolean, IsString, IsNotIn } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';
import { PinDto } from '.';

export class GameConfigDto {
  @ApiProperty()
  public player2: string;

  @ApiProperty({ minimum: 4, maximum: 8 })
  @IsNotEmpty()
  @IsNumber()
  @Min(4)
  @IsNotIn([7])
  @Max(8)
  public pins: number;

  @ApiProperty({ minimum: 1 })
  @IsNotEmpty()
  @IsNumber()
  @Min(1)
  public maxRounds: number;

  @ApiProperty({ type: () => PinDto, isArray: true, minItems: 6 })
  @IsNotEmpty()
  @ArrayMinSize(6)
  public gameColors: PinDto[];

  @ApiProperty()
  @IsNotEmpty()
  @IsString()
  public mode: 'Mode.online_computer' | 'Mode.online_replay' | 'Mode.offline_computer' | 'Mode.offline_player';

  @ApiProperty()
  @IsNotEmpty()
  @IsBoolean()
  public allowDuplicateColors: boolean;

  @ApiProperty()
  @IsNotEmpty()
  @IsBoolean()
  public allowEmptyFields: boolean;
}
