import { Test, TestingModule } from '@nestjs/testing';
import { NotFoundException, BadRequestException } from '@nestjs/common';
import { EvaluateApprovalUseCase } from './evaluate-approval.use-case';
import { IApprovalRuleRepository } from '../../interfaces/repositories/approval-rule-repository.interface';
import { IApprovalEvaluationRepository } from '../../interfaces/repositories/approval-evaluation-repository.interface';

import { IUserRepository } from '../../interfaces/repositories/user-repository.interface';
import { ApprovalRule } from '../../../domain/entities/approval-rule.entity';
import {
  ApprovalEvaluation,
  EvaluationStatus,
} from '../../../domain/entities/approval-evaluation.entity';
import { EvaluateApprovalDto } from '../../dtos/approval/evaluate-approval.dto';
import { User } from '../../../domain/entities/user.entity';
import { Person } from '../../../domain/entities/person.entity';

// Helper functions for creating mock objects
function createMockPerson(overrides: Partial<Person> = {}): Person {
  return {
    id: 'person-123',
    fullName: 'Test User',
    createdAt: new Date(),
    updatedAt: new Date(),
    ...overrides,
  } as Person;
}

function createMockUser(overrides: Partial<User> = {}): User {
  return {
    id: 'user-123',
    email: 'test@example.com',
    isEmailVerified: true,
    password: 'hashedPassword',
    authProvider: 'EMAIL_PASSWORD',
    providerUserId: null,
    role: 'STUDENT',
    isActive: true,
    lastLoginAt: null,
    emailVerificationToken: null,
    passwordResetToken: null,
    passwordResetTokenExpires: null,
    personId: 'person-123',
    person: createMockPerson(),
    refreshTokens: [],
    createdAt: new Date(),
    updatedAt: new Date(),
    get isGoogleAuth() {
      return false;
    },
    get isAppleAuth() {
      return false;
    },
    get isEmailPasswordAuth() {
      return true;
    },
    get isAdmin() {
      return false;
    },
    get isSuperAdmin() {
      return false;
    },
    ...overrides,
  } as User;
}

function createMockApprovalRule(overrides: Partial<ApprovalRule> = {}): ApprovalRule {
  return {
    id: 'rule-123',
    name: 'Test Rule',
    description: null,
    chapterId: null,
    minScoreThreshold: 80,
    maxAttempts: 3,
    allowErrorCarryover: false,
    isActive: true,
    metadata: null,
    createdAt: new Date(),
    updatedAt: new Date(),
    isApplicableToChapter: jest.fn().mockReturnValue(true),
    isScoreApproved: jest.fn().mockReturnValue(true),
    hasSpecialRequirements: jest.fn().mockReturnValue(false),
    getThresholdPercentage: jest.fn().mockReturnValue(80),
    canRetryAfterFailure: jest.fn().mockReturnValue(true),
    ...overrides,
  };
}

function createMockApprovalEvaluation(
  overrides: Partial<ApprovalEvaluation> = {},
): ApprovalEvaluation {
  return {
    id: 'eval-123',
    userId: 'user-123',
    ruleId: 'rule-123',
    chapterId: 'chapter-123',
    score: 85,
    threshold: 80,
    status: EvaluationStatus.APPROVED,
    attemptNumber: 1,
    errorsFromPreviousAttempts: 0,
    feedback: null,
    evaluationData: null,
    evaluatedAt: new Date(),
    user: createMockUser(),
    rule: createMockApprovalRule(),
    createdAt: new Date(),
    updatedAt: new Date(),
    isApproved: jest.fn().mockReturnValue(true),
    isRejected: jest.fn().mockReturnValue(false),
    isPending: jest.fn().mockReturnValue(false),
    getAdjustedScore: jest.fn().mockReturnValue(85),
    approve: jest.fn(),
    reject: jest.fn(),
    hasErrorCarryover: jest.fn().mockReturnValue(false),
    getScoreWithPenalty: jest.fn().mockReturnValue(85),
    ...overrides,
  };
}

describe('EvaluateApprovalUseCase', () => {
  let useCase: EvaluateApprovalUseCase;
  let approvalRuleRepository: jest.Mocked<IApprovalRuleRepository>;
  let approvalEvaluationRepository: jest.Mocked<IApprovalEvaluationRepository>;
  let userRepository: jest.Mocked<IUserRepository>;

  beforeEach(async () => {
    const mockApprovalRuleRepository = {
      create: jest.fn(),
      findById: jest.fn(),
      findByChapterId: jest.fn(),
      findActiveRules: jest.fn(),
      findGlobalRules: jest.fn(),
      findApplicableRules: jest.fn(),
      update: jest.fn(),
      delete: jest.fn(),
      deactivate: jest.fn(),
      activate: jest.fn(),
    };

    const mockApprovalEvaluationRepository = {
      create: jest.fn(),
      findById: jest.fn(),
      findByUserId: jest.fn(),
      findByUserAndChapter: jest.fn(),
      findLatestByUserAndChapter: jest.fn(),
      findByStatus: jest.fn(),
      findPreviousAttempts: jest.fn(),
      countAttempts: jest.fn(),
      update: jest.fn(),
      delete: jest.fn(),
      getEvaluationHistory: jest.fn(),
      getChapterEvaluationStats: jest.fn(),
    };

    const mockApprovalMetricsRepository = {
      create: jest.fn(),
      findById: jest.fn(),
      findByUserId: jest.fn(),
      findByChapterId: jest.fn(),
      findByDateRange: jest.fn(),
      update: jest.fn(),
      delete: jest.fn(),
      createBulkMetrics: jest.fn(),
    };

    const mockUserRepository = {
      create: jest.fn(),
      findById: jest.fn(),
      findByIdWithPerson: jest.fn(),
      findByEmail: jest.fn(),
      findByEmailWithPerson: jest.fn(),
      findByEmailWithPassword: jest.fn(),
      findByEmailVerificationToken: jest.fn(),
      findAll: jest.fn(),
      update: jest.fn(),
      updatePassword: jest.fn(),
      updateRefreshToken: jest.fn(),
      updateLastLoginAt: jest.fn(),
      updateEmailVerificationStatus: jest.fn(),
      setPasswordResetToken: jest.fn(),
      clearPasswordResetToken: jest.fn(),
      setEmailVerificationToken: jest.fn(),
      clearEmailVerificationToken: jest.fn(),
      delete: jest.fn(),
      exists: jest.fn(),
      existsByEmail: jest.fn(),
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        EvaluateApprovalUseCase,
        {
          provide: 'IApprovalRuleRepository',
          useValue: mockApprovalRuleRepository,
        },
        {
          provide: 'IApprovalEvaluationRepository',
          useValue: mockApprovalEvaluationRepository,
        },
        {
          provide: 'IApprovalMetricsRepository',
          useValue: mockApprovalMetricsRepository,
        },
        {
          provide: 'IUserRepository',
          useValue: mockUserRepository,
        },
      ],
    }).compile();

    useCase = module.get<EvaluateApprovalUseCase>(EvaluateApprovalUseCase);
    approvalRuleRepository = module.get('IApprovalRuleRepository');
    approvalEvaluationRepository = module.get('IApprovalEvaluationRepository');
    userRepository = module.get('IUserRepository');
  });

  it('should be defined', () => {
    expect(useCase).toBeDefined();
  });

  describe('execute', () => {
    it('should successfully evaluate approval', async () => {
      // Arrange
      const dto: EvaluateApprovalDto = {
        userId: 'user-123',
        chapterId: '1',
        score: 85,
        additionalData: { timeSpent: 300 },
      };

      const mockRule = createMockApprovalRule({
        chapterId: 'chapter-1',
        minScoreThreshold: 80,
        maxAttempts: 3,
        allowErrorCarryover: false,
      });

      userRepository.findById.mockResolvedValue(createMockUser());
      approvalRuleRepository.findApplicableRules.mockResolvedValue([mockRule]);
      approvalEvaluationRepository.findLatestByUserAndChapter.mockResolvedValue(null);
      approvalEvaluationRepository.countAttempts.mockResolvedValue(0);
      approvalEvaluationRepository.findPreviousAttempts.mockResolvedValue([]);
      approvalEvaluationRepository.create.mockResolvedValue(createMockApprovalEvaluation());

      // Act
      const result = await useCase.execute(dto);

      // Assert
      expect(result.status).toBe(EvaluationStatus.APPROVED);
      expect(result.score).toBe(85);
    });

    it('should handle rejection with error carry over', async () => {
      // Arrange
      const dto: EvaluateApprovalDto = {
        userId: 'user-123',
        chapterId: '1',
        score: 75,
      };

      const mockRule = createMockApprovalRule({
        chapterId: '1',
        minScoreThreshold: 80,
        maxAttempts: 3,
        allowErrorCarryover: true,
      });

      const previousEvaluation = createMockApprovalEvaluation({
        id: 'prev-eval',
        ruleId: 'rule-1',
        chapterId: '1',
        score: 70,
        threshold: 80,
        status: EvaluationStatus.REJECTED,
        attemptNumber: 1,
        errorsFromPreviousAttempts: 8,
      });

      userRepository.findById.mockResolvedValue(createMockUser());
      approvalRuleRepository.findApplicableRules.mockResolvedValue([mockRule]);
      approvalEvaluationRepository.findLatestByUserAndChapter.mockResolvedValue(previousEvaluation);
      approvalEvaluationRepository.countAttempts.mockResolvedValue(1);
      approvalEvaluationRepository.findPreviousAttempts.mockResolvedValue([previousEvaluation]);
      approvalEvaluationRepository.create.mockResolvedValue(createMockApprovalEvaluation());

      // Act
      const result = await useCase.execute(dto);

      // Assert
      expect(result.status).toBe(EvaluationStatus.REJECTED);
      expect(result.score).toBe(75);
    });

    it('should handle chapters 4 and 5 with 100% requirement', async () => {
      // Arrange
      const dto: EvaluateApprovalDto = {
        userId: 'user-123',
        chapterId: '4',
        score: 95,
      };

      const mockRule = {
        id: 'rule-4',
        name: 'Test Rule Chapter 4',
        description: 'Test approval rule for chapter 4',
        chapterId: '4',
        minScoreThreshold: 100,
        maxAttempts: 3,
        allowErrorCarryover: false,
        isActive: true,
        metadata: null,
        createdAt: new Date(),
        updatedAt: new Date(),
        isApplicableToChapter: jest.fn(),
        isScoreApproved: jest.fn(),
        hasSpecialRequirements: jest.fn(),
        getThresholdPercentage: jest.fn(),
        canRetryAfterFailure: jest.fn(),
      } as ApprovalRule;

      userRepository.findById.mockResolvedValue(createMockUser());
      approvalRuleRepository.findApplicableRules.mockResolvedValue([mockRule]);
      approvalEvaluationRepository.findLatestByUserAndChapter.mockResolvedValue(null);
      approvalEvaluationRepository.countAttempts.mockResolvedValue(0);
      approvalEvaluationRepository.findPreviousAttempts.mockResolvedValue([]);
      approvalEvaluationRepository.create.mockResolvedValue(createMockApprovalEvaluation());

      // Act
      const result = await useCase.execute(dto);

      // Assert
      expect(result.status).toBe(EvaluationStatus.REJECTED);
    });

    it('should throw BadRequestException for invalid input', async () => {
      // Arrange
      const dto: EvaluateApprovalDto = {
        userId: 'user-123',
        chapterId: '1',
        score: -5,
      };

      // Act & Assert
      await expect(useCase.execute(dto)).rejects.toThrow(BadRequestException);
    });

    it('should throw NotFoundException when user not found', async () => {
      // Arrange
      const dto: EvaluateApprovalDto = {
        userId: 'invalid-user',
        chapterId: '1',
        score: 80,
      };

      const mockRule = createMockApprovalRule({
        chapterId: '1',
        minScoreThreshold: 80,
        maxAttempts: 3,
        allowErrorCarryover: false,
      });

      userRepository.findById.mockResolvedValue(null); // User not found
      approvalRuleRepository.findApplicableRules.mockResolvedValue([mockRule]);
      approvalEvaluationRepository.countAttempts.mockResolvedValue(0);
      approvalEvaluationRepository.findPreviousAttempts.mockResolvedValue([]);
      approvalEvaluationRepository.findLatestByUserAndChapter.mockResolvedValue(null);
      approvalEvaluationRepository.create.mockResolvedValue(createMockApprovalEvaluation());

      // Act & Assert
      await expect(useCase.execute(dto)).rejects.toThrow(NotFoundException);
    });

    it('should throw NotFoundException when chapter rule not found', async () => {
      // Arrange
      const dto: EvaluateApprovalDto = {
        userId: 'user-123',
        chapterId: '999',
        score: 80,
      };

      userRepository.findById.mockResolvedValue(createMockUser());
      approvalRuleRepository.findApplicableRules.mockResolvedValue([]);

      // Act & Assert
      await expect(useCase.execute(dto)).rejects.toThrow(NotFoundException);
    });

    it('should handle extraData correctly', async () => {
      // Arrange
      const dto: EvaluateApprovalDto = {
        userId: 'user-123',
        chapterId: '1',
        score: 85,
        additionalData: {
          timeSpent: 450,
          hintsUsed: 2,
          questionsAnswered: 10,
          difficulty: 'medium',
        },
      };

      const mockRule = createMockApprovalRule({
        chapterId: '1',
        minScoreThreshold: 80,
        maxAttempts: 3,
        allowErrorCarryover: true,
      });

      userRepository.findById.mockResolvedValue(createMockUser());
      approvalRuleRepository.findApplicableRules.mockResolvedValue([mockRule]);
      approvalEvaluationRepository.findLatestByUserAndChapter.mockResolvedValue(null);
      approvalEvaluationRepository.countAttempts.mockResolvedValue(0);
      approvalEvaluationRepository.findPreviousAttempts.mockResolvedValue([]);
      approvalEvaluationRepository.create.mockResolvedValue(createMockApprovalEvaluation());

      // Act
      const result = await useCase.execute(dto);

      // Assert
      expect(result.status).toBe(EvaluationStatus.APPROVED);
      expect(result.score).toBe(85);
    });

    it('should work without extraData', async () => {
      // Arrange
      const dto: EvaluateApprovalDto = {
        userId: 'user-123',
        chapterId: '1',
        score: 85,
      };

      const mockRule = createMockApprovalRule({
        chapterId: '1',
        minScoreThreshold: 80,
        maxAttempts: 3,
        allowErrorCarryover: true,
      });

      userRepository.findById.mockResolvedValue(createMockUser());
      approvalRuleRepository.findApplicableRules.mockResolvedValue([mockRule]);
      approvalEvaluationRepository.findLatestByUserAndChapter.mockResolvedValue(null);
      approvalEvaluationRepository.countAttempts.mockResolvedValue(0);
      approvalEvaluationRepository.findPreviousAttempts.mockResolvedValue([]);
      approvalEvaluationRepository.create.mockResolvedValue(createMockApprovalEvaluation());

      // Act
      const result = await useCase.execute(dto);

      // Assert
      expect(result.status).toBe(EvaluationStatus.APPROVED);
      expect(result.score).toBe(85);
    });
  });

  describe('error handling and edge cases', () => {
    it('should handle service errors gracefully', async () => {
      // Arrange
      const dto: EvaluateApprovalDto = {
        userId: 'user-123',
        chapterId: '1',
        score: 80,
      };

      userRepository.findById.mockResolvedValue(createMockUser());
      const error = new Error('Database connection failed');
      approvalRuleRepository.findApplicableRules.mockRejectedValue(error);

      // Act & Assert
      await expect(useCase.execute(dto)).rejects.toThrow('Database connection failed');
    });

    it('should validate score boundaries', async () => {
      // Arrange
      const dto: EvaluateApprovalDto = {
        userId: 'user-123',
        chapterId: '1',
        score: 101,
      };

      // Act & Assert
      await expect(useCase.execute(dto)).rejects.toThrow(BadRequestException);
    });

    it('should handle empty or null userId', async () => {
      // Arrange
      const dto: EvaluateApprovalDto = {
        userId: '',
        chapterId: '1',
        score: 80,
      };

      // Act & Assert
      await expect(useCase.execute(dto)).rejects.toThrow(BadRequestException);
    });

    it('should handle empty or null chapterId', async () => {
      // Arrange
      const dto: EvaluateApprovalDto = {
        userId: 'user-123',
        chapterId: null!,
        score: 80,
      };

      // Act & Assert
      await expect(useCase.execute(dto)).rejects.toThrow(BadRequestException);
    });
  });
});
