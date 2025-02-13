import { IsNotEmpty } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class RatingDto {
  @ApiProperty()
  @IsNotEmpty()
  public readonly exactMatch: number;

  @ApiProperty()
  @IsNotEmpty()
  public readonly partMatch: number;

  @ApiProperty()
  @IsNotEmpty()
  public readonly noMatch: number;
}