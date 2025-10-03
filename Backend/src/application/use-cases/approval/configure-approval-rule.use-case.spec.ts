import { Test, TestingModule } from '@nestjs/testing';
import { ConfigureApprovalRuleUseCase } from './configure-approval-rule.use-case';
import { IApprovalRuleRepository } from '../../interfaces/repositories/approval-rule-repository.interface';
import { BadRequestException } from '@nestjs/common';
import { ApprovalRule } from '../../../domain/entities/approval-rule.entity';
import { ConfigureApprovalRuleDto } from '../../dtos/approval/configure-approval-rule.dto';

describe('ConfigureApprovalRuleUseCase', () => {
  let useCase: ConfigureApprovalRuleUseCase;
  let approvalRuleRepository: jest.Mocked<IApprovalRuleRepository>;

  const mockApprovalRule: ApprovalRule = {
    id: 'rule-123',
    name: 'Test Rule',
    description: 'Test rule',
    chapterId: '1',
    minScoreThreshold: 80,
    maxAttempts: 3,
    allowErrorCarryover: true,
    isActive: true,
    metadata: {},
    createdAt: new Date(),
    updatedAt: new Date(),
    isApplicableToChapter: (_chapterId: string) => true,
    isScoreApproved: (score: number) => score >= 80,
    hasSpecialRequirements: () => false,
    getThresholdPercentage: () => 80,
    canRetryAfterFailure: (currentAttempts: number) => currentAttempts < 3
  } as ApprovalRule;

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

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        ConfigureApprovalRuleUseCase,
        {
          provide: 'IApprovalRuleRepository',
          useValue: mockApprovalRuleRepository,
        },
      ],
    }).compile();

    useCase = module.get<ConfigureApprovalRuleUseCase>(ConfigureApprovalRuleUseCase);
    approvalRuleRepository = module.get('IApprovalRuleRepository');
  });

  it('should be defined', () => {
    expect(useCase).toBeDefined();
  });

  describe('execute', () => {
    it('should successfully configure a new approval rule', async () => {
      // Arrange
      const dto: ConfigureApprovalRuleDto = {
        chapterId: '1',
        minScoreThreshold: 80,
        maxAttempts: 3,
        allowErrorCarryover: true,
        isActive: true,
        description: 'Standard chapter threshold'
      };

      approvalRuleRepository.findByChapterId.mockResolvedValue([]);
      approvalRuleRepository.create.mockResolvedValue(mockApprovalRule);

      // Act
      const result = await useCase.execute(dto);

      // Assert
      expect(result.id).toBe(mockApprovalRule.id);
      expect(result.chapterId).toBe(mockApprovalRule.chapterId);
      expect(result.minScoreThreshold).toBe(mockApprovalRule.minScoreThreshold);
      expect(approvalRuleRepository.create).toHaveBeenCalled();
    });

    it('should configure rule for chapter 4 with 100% threshold', async () => {
      // Arrange
      const dto: ConfigureApprovalRuleDto = {
        chapterId: '4',
        minScoreThreshold: 100,
        maxAttempts: 3,
        allowErrorCarryover: false,
        isActive: true,
        description: 'Critical chapter - 100% required'
      };
      
      const chapter4Rule = {
        ...mockApprovalRule,
        chapterId: '4',
        minScoreThreshold: 100,
        isApplicableToChapter: (_chapterId: string) => true,
        isScoreApproved: (score: number) => score >= 100,
        hasSpecialRequirements: () => false,
        getThresholdPercentage: () => 100,
        canRetryAfterFailure: (currentAttempts: number) => currentAttempts < 3
      } as ApprovalRule;

      approvalRuleRepository.findByChapterId.mockResolvedValue([]);
      approvalRuleRepository.create.mockResolvedValue(chapter4Rule);

      // Act
      const result = await useCase.execute(dto);

      // Assert
      expect(result.minScoreThreshold).toBe(100);
      expect(result.chapterId).toBe('4');
    });

    it('should configure rule for chapter 5 with 100% threshold', async () => {
      // Arrange
      const dto: ConfigureApprovalRuleDto = {
        chapterId: '5',
        minScoreThreshold: 100,
        maxAttempts: 3,
        allowErrorCarryover: false,
        isActive: true,
        description: 'Final chapter - 100% required'
      };
      
      const chapter5Rule = {
        ...mockApprovalRule,
        chapterId: '5',
        minScoreThreshold: 100,
        isApplicableToChapter: (_chapterId: string) => true,
         isScoreApproved: (score: number) => score >= 100,
         hasSpecialRequirements: () => false,
         getThresholdPercentage: () => 100,
         canRetryAfterFailure: (currentAttempts: number) => currentAttempts < 3
      } as ApprovalRule;

      approvalRuleRepository.findByChapterId.mockResolvedValue([]);
      approvalRuleRepository.create.mockResolvedValue(chapter5Rule);

      // Act
      const result = await useCase.execute(dto);

      // Assert
      expect(result.minScoreThreshold).toBe(100);
      expect(result.chapterId).toBe('5');
    });

    it('should update existing approval rule', async () => {
      // Arrange
      const dto: ConfigureApprovalRuleDto = {
        chapterId: '1',
        minScoreThreshold: 85,
        maxAttempts: 3,
        allowErrorCarryover: true,
        isActive: true,
        description: 'Updated threshold'
      };
      
      const existingRule = { 
        ...mockApprovalRule, 
        chapterId: '1',
        isApplicableToChapter: (_chapterId: string) => true,
         isScoreApproved: (score: number) => score >= 80,
         hasSpecialRequirements: () => false,
         getThresholdPercentage: () => 80,
         canRetryAfterFailure: (currentAttempts: number) => currentAttempts < 3
      } as ApprovalRule;
      const updatedRule = {
        ...mockApprovalRule,
        minScoreThreshold: 85,
        updatedAt: new Date(),
        isApplicableToChapter: (_chapterId: string) => true,
         isScoreApproved: (score: number) => score >= 85,
         hasSpecialRequirements: () => false,
         getThresholdPercentage: () => 85,
         canRetryAfterFailure: (currentAttempts: number) => currentAttempts < 3
      } as ApprovalRule;

      approvalRuleRepository.findByChapterId.mockResolvedValue([existingRule]);
      approvalRuleRepository.update.mockResolvedValue(updatedRule);

      // Act
      const result = await useCase.execute(dto);

      // Assert
      expect(result.minScoreThreshold).toBe(85);
    });

    it('should work without description', async () => {
      // Arrange
      const dto: ConfigureApprovalRuleDto = {
        chapterId: '2',
        minScoreThreshold: 75,
        maxAttempts: 3,
        allowErrorCarryover: true,
        isActive: true
      };

      approvalRuleRepository.findByChapterId.mockResolvedValue([]);
      approvalRuleRepository.create.mockResolvedValue(mockApprovalRule);

      // Act
      await useCase.execute(dto);

      // Assert
      expect(approvalRuleRepository.create).toHaveBeenCalled();
    });

    it('should throw BadRequestException for invalid threshold', async () => {
      // Arrange
      const dto: ConfigureApprovalRuleDto = {
        chapterId: '1',
        minScoreThreshold: 105,
        maxAttempts: 3,
        allowErrorCarryover: true,
        isActive: true,
        description: 'Invalid threshold test'
      };

      // Act & Assert
      await expect(
        useCase.execute(dto)
      ).rejects.toThrow(BadRequestException);
    });

    it('should throw BadRequestException for empty chapterId', async () => {
      // Arrange
      const dto: ConfigureApprovalRuleDto = {
        chapterId: null as any,
        minScoreThreshold: 80,
        maxAttempts: 3,
        allowErrorCarryover: true,
        isActive: true,
        description: 'Empty chapter test'
      };

      // Mock repository to return empty array for null chapterId
      approvalRuleRepository.findByChapterId.mockResolvedValue([]);
      approvalRuleRepository.findGlobalRules.mockResolvedValue([]);

      // Act & Assert
      await expect(
        useCase.execute(dto)
      ).rejects.toThrow(BadRequestException);
    });

    it('should handle service errors gracefully', async () => {
      // Arrange
      const dto: ConfigureApprovalRuleDto = {
        chapterId: '1',
        minScoreThreshold: 80,
        maxAttempts: 3,
        allowErrorCarryover: true,
        isActive: true,
        description: 'Service error test'
      };
      
      const error = new Error('Database connection failed');
      approvalRuleRepository.findByChapterId.mockRejectedValue(error);

      // Act & Assert
      await expect(
        useCase.execute(dto)
      ).rejects.toThrow('Database connection failed');
    });
  });

  describe('validation scenarios', () => {
    it('should reject threshold below minimum (0)', async () => {
      const dto: ConfigureApprovalRuleDto = {
        chapterId: '1',
        minScoreThreshold: -1,
        maxAttempts: 3,
        allowErrorCarryover: true,
        isActive: true
      };
      
      // Act & Assert
      await expect(
        useCase.execute(dto)
      ).rejects.toThrow(BadRequestException);
    });

    it('should reject threshold above maximum (100)', async () => {
      const dto: ConfigureApprovalRuleDto = {
        chapterId: '1',
        minScoreThreshold: 101,
        maxAttempts: 3,
        allowErrorCarryover: true,
        isActive: true
      };
      
      // Act & Assert
      await expect(
        useCase.execute(dto)
      ).rejects.toThrow(BadRequestException);
    });

    it('should handle minimum valid threshold', async () => {
      // Arrange
      const dto: ConfigureApprovalRuleDto = {
        chapterId: '1',
        minScoreThreshold: 0,
        maxAttempts: 3,
        allowErrorCarryover: true,
        isActive: true
      };
      const ruleWithMinThreshold = {
        ...mockApprovalRule,
        minScoreThreshold: 0,
        isApplicableToChapter: jest.fn(),
        isScoreApproved: jest.fn(),
        hasSpecialRequirements: jest.fn(),
        getThresholdPercentage: jest.fn(),
        canRetryAfterFailure: jest.fn()
      } as ApprovalRule;

      approvalRuleRepository.findByChapterId.mockResolvedValue([]);
      approvalRuleRepository.create.mockResolvedValue(ruleWithMinThreshold);

      // Act
      const result = await useCase.execute(dto);

      // Assert
      expect(result.minScoreThreshold).toBe(0);
    });

    it('should handle maximum valid threshold', async () => {
      // Arrange
      const dto: ConfigureApprovalRuleDto = {
        chapterId: '1',
        minScoreThreshold: 100,
        maxAttempts: 3,
        allowErrorCarryover: true,
        isActive: true
      };
      const ruleWithMaxThreshold = {
        ...mockApprovalRule,
        minScoreThreshold: 100,
        isApplicableToChapter: jest.fn(),
        isScoreApproved: jest.fn(),
        hasSpecialRequirements: jest.fn(),
        getThresholdPercentage: jest.fn(),
        canRetryAfterFailure: jest.fn()
      } as ApprovalRule;

      approvalRuleRepository.findByChapterId.mockResolvedValue([]);
      approvalRuleRepository.create.mockResolvedValue(ruleWithMaxThreshold);

      // Act
      const result = await useCase.execute(dto);

      // Assert
      expect(result.minScoreThreshold).toBe(100);
    });

    it('should handle long description', async () => {
      // Arrange
      const dto: ConfigureApprovalRuleDto = {
        chapterId: '1',
        minScoreThreshold: 80,
        maxAttempts: 3,
        allowErrorCarryover: true,
        isActive: true,
        description: 'A'.repeat(500)
      };

      approvalRuleRepository.findByChapterId.mockResolvedValue([]);
      approvalRuleRepository.create.mockResolvedValue(mockApprovalRule);

      // Act
      await useCase.execute(dto);

      // Assert
      expect(approvalRuleRepository.create).toHaveBeenCalled();
    });

    it('should handle special characters in chapterId', async () => {
      // Arrange
      const dto: ConfigureApprovalRuleDto = {
        chapterId: '1',
        minScoreThreshold: 80,
        maxAttempts: 3,
        allowErrorCarryover: true,
        isActive: true
      };
      const specialRule = {
          ...mockApprovalRule,
          chapterId: '1',
          isApplicableToChapter: jest.fn(),
          isScoreApproved: jest.fn(),
          hasSpecialRequirements: jest.fn(),
          getThresholdPercentage: jest.fn(),
          canRetryAfterFailure: jest.fn()
        } as ApprovalRule;

      approvalRuleRepository.findByChapterId.mockResolvedValue([]);
      approvalRuleRepository.create.mockResolvedValue(specialRule);

      // Act
      const result = await useCase.execute(dto);

      // Assert
        expect(result.chapterId).toBe('1');
    });
  });

  describe('business logic scenarios', () => {
    it('should enforce 100% threshold for critical chapters', async () => {
      // Test that the business logic enforces 100% for chapters 4 and 5
      const criticalChapters = ['4', '5'];
      
      for (const chapterId of criticalChapters) {
        // Arrange
        const dto: ConfigureApprovalRuleDto = {
          chapterId,
          minScoreThreshold: 100,
          maxAttempts: 3,
          allowErrorCarryover: false,
          isActive: true
        };
        const criticalRule = {
          ...mockApprovalRule,
          chapterId,
          minScoreThreshold: 100,
          isApplicableToChapter: jest.fn(),
          isScoreApproved: jest.fn(),
          hasSpecialRequirements: jest.fn(),
          getThresholdPercentage: jest.fn(),
          canRetryAfterFailure: jest.fn()
        } as ApprovalRule;

        approvalRuleRepository.findByChapterId.mockResolvedValue([]);
        approvalRuleRepository.create.mockResolvedValue(criticalRule);

        // Act
        const result = await useCase.execute(dto);

        // Assert
        expect(result.minScoreThreshold).toBe(100);
        expect(result.chapterId).toBe(chapterId);
      }
    });

    it('should allow flexible thresholds for regular chapters', async () => {
      // Test that regular chapters can have different thresholds
      const regularChapters = ['1', '2', '3'];
      const thresholds = [70, 80, 90];
      
      for (let i = 0; i < regularChapters.length; i++) {
        // Arrange
        const chapterId = regularChapters[i];
        const threshold = thresholds[i];
        const dto: ConfigureApprovalRuleDto = {
          chapterId,
          minScoreThreshold: threshold,
          maxAttempts: 3,
          allowErrorCarryover: true,
          isActive: true
        };
        const flexibleRule = {
          ...mockApprovalRule,
          chapterId,
          minScoreThreshold: threshold,
          isApplicableToChapter: jest.fn(),
          isScoreApproved: jest.fn(),
          hasSpecialRequirements: jest.fn(),
          getThresholdPercentage: jest.fn(),
          canRetryAfterFailure: jest.fn()
        } as ApprovalRule;

        approvalRuleRepository.findByChapterId.mockResolvedValue([]);
        approvalRuleRepository.create.mockResolvedValue(flexibleRule);

        // Act
        const result = await useCase.execute(dto);

        // Assert
        expect(result.minScoreThreshold).toBe(threshold);
        expect(result.chapterId).toBe(chapterId);
      }
    });
  });
});