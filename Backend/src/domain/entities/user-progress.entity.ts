import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  Index,
  ManyToOne,
  JoinColumn,
} from 'typeorm';
import { User } from './user.entity';

@Entity('user_progress')
@Index(['userId'], { unique: false })
export class UserProgress {
  @PrimaryGeneratedColumn('uuid')
  readonly id!: string;

  @Column({ type: 'uuid' })
  userId!: string;

  @Column({ type: 'uuid' })
  chapterId!: string;

  @Column({ type: 'numeric', precision: 10, scale: 2, nullable: true })
  score!: number | null;

  @Column({ type: 'timestamptz' })
  lastActivity!: Date;

  @Column({ type: 'jsonb', nullable: true })
  extraData!: Record<string, any> | null;

  @ManyToOne(() => User, { eager: false })
  @JoinColumn({ name: 'userId' })
  user!: User;

  @CreateDateColumn({ type: 'timestamptz' })
  readonly createdAt!: Date;

  @UpdateDateColumn({ type: 'timestamptz' })
  readonly updatedAt!: Date;
}
