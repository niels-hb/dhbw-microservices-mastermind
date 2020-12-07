import { IsNotEmpty } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class FollowingDto {
  @ApiProperty()
  @IsNotEmpty()
  public readonly username: string;

  @ApiProperty()
  @IsNotEmpty()
  public readonly status: string;
}
