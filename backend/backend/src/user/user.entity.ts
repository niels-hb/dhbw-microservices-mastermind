import { Entity, Column, BeforeInsert, ObjectIdColumn, ObjectID } from 'typeorm';
import { IsEmail } from 'class-validator';
import * as argon2 from 'argon2';
import { FollowingDto } from './dto/following.dto';

@Entity('user')
export class UserEntity {
  @ObjectIdColumn()
  public id: ObjectID;

  @Column()
  public username: string;

  @Column()
  @IsEmail()
  public email: string;

  @Column({default: ''})
  public bio: string;

  @Column()
  public currentGame: string;

  @Column()
  public followerCount: number;

  @Column()
  public password: string;

  @Column()
  public following: FollowingDto[];

  @BeforeInsert()
  public async hashPassword(): Promise<void> {
    this.password = await argon2.hash(this.password);
  }
}
