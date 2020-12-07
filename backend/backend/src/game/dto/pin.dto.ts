import { IsNotEmpty } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class PinDto {
  @ApiProperty()
  @IsNotEmpty()
  public readonly id: number;

  @ApiProperty()
  @IsNotEmpty()
  public readonly name: string;
}