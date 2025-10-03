import { Test, TestingModule } from '@nestjs/testing';
import { NotFoundException, BadRequestException } from '@nestjs/common';
import { CreateProgressUseCase } from '../create-progress.use-case';
import { IUserProgressRepository } from '../../../interfaces/repositories/user-progress-repository.interface';
import { IUserRepository } from '../../../interfaces/repositories/user-repository.interface';
import { CreateProgressDto } from '../../../dtos/progress/create-progress.dto';
import { User } from '../../../../domain/entities/user.entity';

describe('CreateProgressUseCase', () => {
  let useCase: CreateProgressUseCase;
  let mockUserProgressRepository: jest.Mocked<IUserProgressRepository>;
  let mockUserRepository: jest.Mocked<IUserRepository>;

  beforeEach(async () => {
    const mockUserProgressRepo: jest.Mocked<IUserProgressRepository> = {
      createOrUpdate: jest.fn(),
    } as any;

    const mockUserRepo: jest.Mocked<IUserRepository> = {
      findById: jest.fn(),
    } as any;

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        CreateProgressUseCase,
        { provide: 'IUserProgressRepository', useValue: mockUserProgressRepo },
        { provide: 'IUserRepository', useValue: mockUserRepo },
      ],
    }).compile();

    useCase = module.get<CreateProgressUseCase>(CreateProgressUseCase);
    mockUserProgressRepository = module.get('IUserProgressRepository');
    mockUserRepository = module.get('IUserRepository');
  });

  describe('execute', () => {
    const mockUserId = 'user-123';
    const mockChapterId = 'chapter-456';

    const validCreateProgressDto: CreateProgressDto = {
      chapterId: mockChapterId,
      score: 85.5,
      extraData: { vocab: { chapter: 2, lastWord: 'apple' } },
    };

    const mockUser = {
      id: mockUserId,
      email: 'test@example.com',
    } as User;

    const mockProgress = {
      id: 'progress-789',
      userId: mockUserId,
      chapterId: mockChapterId,
      score: 85.5,
      lastActivity: new Date(),
      chapterCompleted: false,
      chapterCompletionDate: null,
      vocabularyItemsLearned: 10,
      totalVocabularyItems: 20,
      extraData: { vocab: { chapter: 2, lastWord: 'apple' } },
      user: mockUser,
      chapter: null,
      createdAt: new Date(),
      updatedAt: new Date(),
      // Métodos de dominio mockeados
      getProgressPercentage: jest.fn().mockReturnValue(50),
      markChapterCompleted: jest.fn(),
      incrementVocabularyLearned: jest.fn(),
      isChapterInProgress: jest.fn().mockReturnValue(true),
      canCompleteChapter: jest.fn().mockReturnValue(false),
    } as any;

    it('should create progress successfully when user exists', async () => {
      mockUserRepository.findById.mockResolvedValue(mockUser);
      mockUserProgressRepository.createOrUpdate.mockResolvedValue(mockProgress);

      const result = await useCase.execute(mockUserId, validCreateProgressDto);

      expect(mockUserRepository.findById).toHaveBeenCalledWith(mockUserId);
      expect(mockUserProgressRepository.createOrUpdate).toHaveBeenCalledWith(
        mockUserId,
        validCreateProgressDto,
      );

      // Verificamos los campos principales devueltos por el use case
      expect(result).toMatchObject({
        id: mockProgress.id,
        userId: mockProgress.userId,
        chapterId: mockProgress.chapterId,
        score: mockProgress.score,
        extraData: mockProgress.extraData,
      });
      expect(result.lastActivity).toBeInstanceOf(Date);
      expect(result.createdAt).toBeInstanceOf(Date);
      expect(result.updatedAt).toBeInstanceOf(Date);
    });

    it('should throw NotFoundException when user does not exist', async () => {
      mockUserRepository.findById.mockResolvedValue(null);

      await expect(useCase.execute(mockUserId, validCreateProgressDto)).rejects.toThrow(
        NotFoundException,
      );

      expect(mockUserRepository.findById).toHaveBeenCalledWith(mockUserId);
      expect(mockUserProgressRepository.createOrUpdate).not.toHaveBeenCalled();
    });

    it('should throw BadRequestException when score is out of range (>100)', async () => {
      const invalidDto = { ...validCreateProgressDto, score: 150 };
      mockUserRepository.findById.mockResolvedValue(mockUser);

      await expect(useCase.execute(mockUserId, invalidDto)).rejects.toThrow(BadRequestException);
    });

    it('should throw BadRequestException when score is negative', async () => {
      const invalidDto = { ...validCreateProgressDto, score: -10 };
      mockUserRepository.findById.mockResolvedValue(mockUser);

      await expect(useCase.execute(mockUserId, invalidDto)).rejects.toThrow(BadRequestException);
    });

    it('should handle progress without score', async () => {
      const dtoWithoutScore = { chapterId: mockChapterId } as CreateProgressDto;

      const progressWithoutScore = {
        ...mockProgress,
        score: null,
        getProgressPercentage: jest.fn().mockReturnValue(50),
        markChapterCompleted: jest.fn(),
        incrementVocabularyLearned: jest.fn(),
        isChapterInProgress: jest.fn().mockReturnValue(true),
        canCompleteChapter: jest.fn().mockReturnValue(false),
      } as any;

      mockUserRepository.findById.mockResolvedValue(mockUser);
      mockUserProgressRepository.createOrUpdate.mockResolvedValue(progressWithoutScore);

      const result = await useCase.execute(mockUserId, dtoWithoutScore);

      expect(result.score).toBeNull();
      expect(mockUserProgressRepository.createOrUpdate).toHaveBeenCalledWith(
        mockUserId,
        dtoWithoutScore,
      );
    });
  });
});
