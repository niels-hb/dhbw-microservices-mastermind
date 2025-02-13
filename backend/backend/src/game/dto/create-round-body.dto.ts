import { IsNotEmpty, ArrayMinSize, ArrayMaxSize } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';
import { PinDto } from '.';

export class CreateRoundBodyDto {

  @ApiProperty({
    isArray: true,
    type: PinDto
  })
  @IsNotEmpty()
  @ArrayMinSize(4)
  @ArrayMaxSize(8)
  public readonly guess: PinDto[];
}
