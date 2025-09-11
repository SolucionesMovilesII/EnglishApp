import { Injectable } from '@nestjs/common';
import { Repository } from 'typeorm';
import { InjectRepository } from '@nestjs/typeorm';
import { DailyLives } from '../../domain/entities/daily-lives.entity';
import { IDailyLivesRepository } from '../../application/interfaces/repositories/daily-lives-repository.interface';

@Injectable()
export class DailyLivesRepository implements IDailyLivesRepository {
  constructor(
    @InjectRepository(DailyLives)
    private readonly repository: Repository<DailyLives>,
  ) {}

  async findByUserId(userId: string): Promise<DailyLives | null> {
    return await this.repository.findOne({
      where: { userId },
      order: { lastResetDate: 'DESC' },
    });
  }

  async findByUserIdAndDate(userId: string, date: Date): Promise<DailyLives | null> {
    const dateString = date.toISOString().split('T')[0];
    return await this.repository.findOne({
      where: {
        userId,
        lastResetDate: dateString as any,
      },
    });
  }

  async createOrUpdateForUser(userId: string): Promise<DailyLives> {
    const today = new Date();
    const todayString = today.toISOString().split('T')[0];

    let dailyLives = await this.findByUserIdAndDate(userId, today);

    if (!dailyLives) {
      // Create new daily lives record
      dailyLives = this.repository.create({
        userId,
        currentLives: 5,
        lastResetDate: new Date(todayString),
      });
    } else if (dailyLives.needsReset) {
      // Reset lives for today
      dailyLives.resetLives();
    }

    return await this.repository.save(dailyLives);
  }

  async consumeLife(userId: string): Promise<DailyLives | null> {
    const queryRunner = this.repository.manager.connection.createQueryRunner();
    await queryRunner.connect();
    await queryRunner.startTransaction();

    try {
      // Find current daily lives record with lock for update
      const dailyLives = await queryRunner.manager.findOne(DailyLives, {
        where: { userId },
        order: { lastResetDate: 'DESC' },
        lock: { mode: 'pessimistic_write' },
      });

      if (!dailyLives) {
        await queryRunner.rollbackTransaction();
        return null;
      }

      // Check if reset is needed
      if (dailyLives.needsReset) {
        dailyLives.resetLives();
      }

      // Try to consume life
      const canConsume = dailyLives.consumeLife();
      if (!canConsume) {
        await queryRunner.rollbackTransaction();
        return null;
      }

      const savedDailyLives = await queryRunner.manager.save(dailyLives);
      await queryRunner.commitTransaction();
      return savedDailyLives;
    } catch (error) {
      await queryRunner.rollbackTransaction();
      throw error;
    } finally {
      await queryRunner.release();
    }
  }

  async resetDailyLives(userId: string): Promise<DailyLives | null> {
    const dailyLives = await this.findByUserId(userId);
    if (!dailyLives) {
      return null;
    }

    dailyLives.resetLives();
    return await this.repository.save(dailyLives);
  }

  async resetAllUsersLives(): Promise<number> {
    const today = new Date();
    const todayString = today.toISOString().split('T')[0];

    const result = await this.repository
      .createQueryBuilder()
      .update(DailyLives)
      .set({
        currentLives: 5,
        lastResetDate: todayString as any,
        updatedAt: () => 'CURRENT_TIMESTAMP',
      })
      .where('lastResetDate < :today', { today: todayString })
      .execute();

    return result.affected || 0;
  }

  async exists(userId: string): Promise<boolean> {
    const count = await this.repository.count({ where: { userId } });
    return count > 0;
  }
}
