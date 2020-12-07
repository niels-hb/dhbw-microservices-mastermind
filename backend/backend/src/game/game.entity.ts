import { Entity, Column, ObjectIdColumn, ObjectID } from 'typeorm';
import { PinDto, GameConfigDto, RoundDto } from './dto';
import { IsNotEmpty } from 'class-validator';

@Entity('game')
export class GameEntity {
  @ObjectIdColumn()
  public id: ObjectID;

  @Column()
  public refernceGameId: string;

  @Column()
  public username: string;

  @Column()
  public status: string;

  @Column()
  public undoUsed: boolean;

  @IsNotEmpty()
  @Column()
  public config: GameConfigDto;

  @IsNotEmpty()
  @Column()
  public solution: PinDto[];

  @IsNotEmpty()
  @Column()
  public rounds: RoundDto[];
}
