import { Injectable } from '@nestjs/common';
import { Repository } from 'typeorm';
import { InjectRepository } from '@nestjs/typeorm';
import {
  PracticeSession,
  PracticeType,
  PracticeStatus,
} from '../../domain/entities/practice-session.entity';
import { IPracticeSessionRepository } from '../../application/interfaces/repositories/practice-session-repository.interface';

@Injectable()
export class PracticeSessionRepository implements IPracticeSessionRepository {
  constructor(
    @InjectRepository(PracticeSession)
    private readonly repository: Repository<PracticeSession>,
  ) {}

  async create(practiceSession: PracticeSession): Promise<PracticeSession> {
    return await this.repository.save(practiceSession);
  }

  async findById(id: string): Promise<PracticeSession | null> {
    return await this.repository.findOne({
      where: { id },
      relations: ['chapter'],
    });
  }

  async findByUserId(userId: string, limit = 10, offset = 0): Promise<PracticeSession[]> {
    return await this.repository.find({
      where: { userId },
      relations: ['chapter'],
      order: { createdAt: 'DESC' },
      take: limit,
      skip: offset,
    });
  }

  async findByUserIdAndType(
    userId: string,
    practiceType: PracticeType,
    limit = 10,
    offset = 0,
  ): Promise<PracticeSession[]> {
    return await this.repository.find({
      where: { userId, practiceType },
      relations: ['chapter'],
      order: { createdAt: 'DESC' },
      take: limit,
      skip: offset,
    });
  }

  async findByUserIdAndChapter(
    userId: string,
    chapterId: string,
    practiceType?: PracticeType,
  ): Promise<PracticeSession[]> {
    const where: Partial<{ userId: string; chapterId: string; practiceType: PracticeType }> = {
      userId,
      chapterId,
    };
    if (practiceType) {
      where.practiceType = practiceType;
    }

    return await this.repository.find({
      where,
      relations: ['chapter'],
      order: { createdAt: 'DESC' },
    });
  }

  async update(id: string, updates: Partial<PracticeSession>): Promise<PracticeSession> {
    // Exclude relation properties and handle extraData type conversion
    const { chapter, ...updateData } = updates;

    // Create the final update object with proper typing
    const finalUpdateData: any = { ...updateData };

    await this.repository.update(id, finalUpdateData);
    const updated = await this.findById(id);
    if (!updated) {
      throw new Error('Practice session not found after update');
    }
    return updated;
  }

  async delete(id: string): Promise<void> {
    await this.repository.delete(id);
  }

  async findActiveSessionsByUser(userId: string): Promise<PracticeSession[]> {
    return await this.repository.find({
      where: {
        userId,
        status: PracticeStatus.IN_PROGRESS,
      },
      relations: ['chapter'],
      order: { createdAt: 'DESC' },
    });
  }

  async markAsCompleted(id: string, score: number): Promise<PracticeSession> {
    const session = await this.findById(id);
    if (!session) {
      throw new Error('Practice session not found');
    }

    session.markAsCompleted(score);
    return await this.repository.save(session);
  }

  async markAsAbandoned(id: string): Promise<PracticeSession> {
    const session = await this.findById(id);
    if (!session) {
      throw new Error('Practice session not found');
    }

    session.markAsAbandoned();
    return await this.repository.save(session);
  }
}
