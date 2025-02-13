import { IsNotEmpty } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';
import { RatingDto } from './rating.dto';
import { PinDto } from '.';

export class RoundDto {
    @ApiProperty()
    @IsNotEmpty()
    public readonly id: number;

    @ApiProperty({
        isArray: true,
        type: PinDto
    })
    @IsNotEmpty()
    public readonly guess: PinDto[];
      
    @ApiProperty()
    @IsNotEmpty()
    public readonly rating: RatingDto;
}