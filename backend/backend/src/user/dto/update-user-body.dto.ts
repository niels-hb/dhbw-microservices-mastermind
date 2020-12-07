import { IsNotEmpty } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';
import { UpdateUserDto } from '.';

export class UpdateUserBodyDto {

  @ApiProperty()
  @IsNotEmpty()
  public readonly user: UpdateUserDto;
}
