import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ScheduleModule } from '@nestjs/schedule';
import { DailyLives } from '../../domain/entities/daily-lives.entity';
import { DailyLivesRepository } from '../../infrastructure/repositories/daily-lives.repository';
import { DailyLivesResetService } from '../services/cron/daily-lives-reset.service';

@Module({
  imports: [
    // Schedule module for cron jobs
    ScheduleModule.forRoot(),

    // TypeORM entities
    TypeOrmModule.forFeature([DailyLives]),
  ],
  providers: [
    // Repositories
    {
      provide: 'IDailyLivesRepository',
      useClass: DailyLivesRepository,
    },

    // Cron services
    DailyLivesResetService,
  ],
  exports: [DailyLivesResetService, 'IDailyLivesRepository'],
})
export class CronModule {}
