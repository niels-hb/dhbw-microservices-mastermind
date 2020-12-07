import { ApiProperty } from '@nestjs/swagger';
import { IsEmail, IsNotEmpty } from 'class-validator';

export class UpdateUserDto {
  @ApiProperty()
  @IsEmail()
  @IsNotEmpty()
  public readonly email: string;
  
  @ApiProperty()
  public readonly bio: string;

  @ApiProperty()
  public readonly password: string;
}
