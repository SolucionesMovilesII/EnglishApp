import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UserProgress } from '../../domain/entities/user-progress.entity';
import { User } from '../../domain/entities/user.entity';
import { ProgressController } from '../controllers/progress/progress.controller';
import { CreateProgressUseCase } from '../../application/use-cases/progress/create-progress.use-case';
import { GetUserProgressUseCase } from '../../application/use-cases/progress/get-user-progress.use-case';
import { UpdateProgressUseCase } from '../../application/use-cases/progress/update-progress.use-case';
import { UserProgressRepository } from '../../infrastructure/repositories/user-progress.repository';
import { UserRepository } from '../../infrastructure/repositories/user.repository';

@Module({
  imports: [TypeOrmModule.forFeature([UserProgress, User])],
  controllers: [ProgressController],
  providers: [
    // Progress Use Cases
    CreateProgressUseCase,
    GetUserProgressUseCase,
    UpdateProgressUseCase,

    // Repositories
    UserProgressRepository,
    UserRepository,

    // Interface bindings
    {
      provide: 'IUserProgressRepository',
      useClass: UserProgressRepository,
    },
    {
      provide: 'IUserRepository',
      useClass: UserRepository,
    },
  ],
  exports: [
    CreateProgressUseCase,
    GetUserProgressUseCase,
    UpdateProgressUseCase,
    UserProgressRepository,
    UserRepository,
    'IUserProgressRepository',
    'IUserRepository',
  ],
})
export class ProgressModule {}
