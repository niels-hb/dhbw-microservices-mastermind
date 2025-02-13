import { FollowingDto } from './following.dto';
import { ApiProperty } from '@nestjs/swagger';
import { IsEmail, IsNotEmpty } from 'class-validator';
import { GameData } from '../../game/dto';

export class UserDto {
    @ApiProperty({
        required: false
    })
    public readonly id?: any;

    @ApiProperty()
    public readonly username: string;

    @ApiProperty({
        isArray: true,
        type: FollowingDto
    })
    public readonly following: FollowingDto[];

    @ApiProperty()
    @IsEmail()
    @IsNotEmpty()
    public readonly email: string;
    
    @ApiProperty()
    public readonly bio: string;

    @ApiProperty()
    public readonly currentGame: GameData;

    @ApiProperty()
    public readonly followerCount: number;

    @ApiProperty({
        required: false
    })
    public readonly token?: string;
}