import { Injectable, Inject, Logger } from '@nestjs/common';
import { IApprovalEvaluationRepository } from '../../interfaces/repositories/approval-evaluation-repository.interface';
import {
  ApprovalEvaluation,
  EvaluationStatus,
} from '../../../domain/entities/approval-evaluation.entity';

export interface GetEvaluationHistoryRequest {
  userId: string;
  chapterId?: string;
  status?: EvaluationStatus;
  limit?: number;
  offset?: number;
}

export interface EvaluationHistoryItem {
  id: string;
  chapterId: string;
  score: number;
  threshold: number;
  status: EvaluationStatus;
  attemptNumber: number;
  errorsFromPreviousAttempts: number;
  feedback?: string;
  evaluatedAt: Date;
  evaluationData?: Record<string, unknown>;
}

export interface GetEvaluationHistoryResponse {
  evaluations: EvaluationHistoryItem[];
  total: number;
  hasMore: boolean;
}

@Injectable()
export class GetEvaluationHistoryUseCase {
  private readonly logger = new Logger(GetEvaluationHistoryUseCase.name);

  constructor(
    @Inject('IApprovalEvaluationRepository')
    private readonly approvalEvaluationRepository: IApprovalEvaluationRepository,
  ) {}

  async execute(
    evaluationRequest: GetEvaluationHistoryRequest,
  ): Promise<GetEvaluationHistoryResponse> {
    this.logger.log(`Getting evaluation history for user: ${evaluationRequest.userId}`);

    const limit = Math.min(evaluationRequest.limit || 10, 100); // Cap at 100
    const offset = evaluationRequest.offset || 0;

    const [evaluations, totalCount] = await Promise.all([
      this.getFilteredEvaluations(evaluationRequest, limit, offset),
      this.getTotalCount(evaluationRequest),
    ]);

    const hasMore = evaluations.length === limit;

    return {
      evaluations: evaluations.map(evaluation => this.mapToHistoryItem(evaluation)),
      total: totalCount,
      hasMore,
    };
  }

  private async getFilteredEvaluations(
    evaluationRequest: GetEvaluationHistoryRequest,
    limit: number,
    offset: number,
  ): Promise<ApprovalEvaluation[]> {
    if (evaluationRequest.chapterId && evaluationRequest.status) {
      // Filter by both chapter and status - get all and filter manually
      const allEvaluations = await this.approvalEvaluationRepository.findByUserAndChapter(
        evaluationRequest.userId,
        evaluationRequest.chapterId,
      );
      return allEvaluations
        .filter(evaluation => evaluation.status === evaluationRequest.status)
        .slice(offset, offset + limit);
    } else if (evaluationRequest.chapterId) {
      // Filter by chapter only
      const allEvaluations = await this.approvalEvaluationRepository.findByUserAndChapter(
        evaluationRequest.userId,
        evaluationRequest.chapterId,
      );
      return allEvaluations
        .filter(evaluation => evaluation.userId === evaluationRequest.userId)
        .slice(offset, offset + limit);
    } else if (evaluationRequest.status) {
      // Filter by status only
      const allEvaluations = await this.approvalEvaluationRepository.findByStatus(
        evaluationRequest.status,
      );
      return allEvaluations.slice(offset, offset + limit);
    } else {
      // No filters, get all evaluations for user
      const allEvaluations = await this.approvalEvaluationRepository.findByUserId(
        evaluationRequest.userId,
      );
      return allEvaluations.slice(offset, offset + limit);
    }
  }

  private async getTotalCount(evaluationRequest: GetEvaluationHistoryRequest): Promise<number> {
    if (evaluationRequest.chapterId && evaluationRequest.status) {
      const evaluations = await this.approvalEvaluationRepository.findByUserAndChapter(
        evaluationRequest.userId,
        evaluationRequest.chapterId,
      );
      return evaluations.filter(evaluation => evaluation.status === evaluationRequest.status)
        .length;
    } else if (evaluationRequest.chapterId) {
      const evaluations = await this.approvalEvaluationRepository.findByUserAndChapter(
        evaluationRequest.userId,
        evaluationRequest.chapterId,
      );
      return evaluations.length;
    } else if (evaluationRequest.status) {
      const evaluations = await this.approvalEvaluationRepository.findByStatus(
        evaluationRequest.status,
      );
      return evaluations.filter(evaluation => evaluation.userId === evaluationRequest.userId)
        .length;
    } else {
      const evaluations = await this.approvalEvaluationRepository.findByUserId(
        evaluationRequest.userId,
      );
      return evaluations.length;
    }
  }

  private mapToHistoryItem(evaluation: ApprovalEvaluation): EvaluationHistoryItem {
    return {
      id: evaluation.id,
      chapterId: evaluation.chapterId,
      score: evaluation.score,
      threshold: evaluation.threshold,
      status: evaluation.status,
      attemptNumber: evaluation.attemptNumber,
      errorsFromPreviousAttempts: evaluation.errorsFromPreviousAttempts,
      ...(evaluation.feedback && { feedback: evaluation.feedback }),
      evaluatedAt: evaluation.evaluatedAt,
      ...(evaluation.evaluationData && { evaluationData: evaluation.evaluationData }),
    };
  }
}

@Injectable()
export class GetChapterEvaluationStatsUseCase {
  private readonly logger = new Logger(GetChapterEvaluationStatsUseCase.name);

  constructor(
    @Inject('IApprovalEvaluationRepository')
    private readonly approvalEvaluationRepository: IApprovalEvaluationRepository,
  ) {}

  async execute(chapterId: string): Promise<{
    totalEvaluations: number;
    approvedCount: number;
    rejectedCount: number;
    averageScore: number;
    averageAttempts: number;
  }> {
    this.logger.log(`Getting evaluation stats for chapter: ${chapterId}`);

    try {
      const stats = await this.approvalEvaluationRepository.getChapterEvaluationStats(chapterId);

      this.logger.log(`Retrieved stats for chapter: ${chapterId}`);

      return stats;
    } catch (error) {
      this.logger.error(
        `Error getting chapter evaluation stats: ${error instanceof Error ? error.message : String(error)}`,
      );
      throw error;
    }
  }
}

@Injectable()
export class GetLatestEvaluationUseCase {
  private readonly logger = new Logger(GetLatestEvaluationUseCase.name);

  constructor(
    @Inject('IApprovalEvaluationRepository')
    private readonly approvalEvaluationRepository: IApprovalEvaluationRepository,
  ) {}

  async execute(userId: string, chapterId: string): Promise<EvaluationHistoryItem | null> {
    this.logger.log(`Getting latest evaluation for user: ${userId}, chapter: ${chapterId}`);

    try {
      const evaluation = await this.approvalEvaluationRepository.findLatestByUserAndChapter(
        userId,
        chapterId,
      );

      if (!evaluation) {
        return null;
      }

      return this.mapToHistoryItem(evaluation);
    } catch (error) {
      this.logger.error(
        `Error getting latest evaluation: ${error instanceof Error ? error.message : String(error)}`,
      );
      throw error;
    }
  }

  private mapToHistoryItem(evaluation: ApprovalEvaluation): EvaluationHistoryItem {
    return {
      id: evaluation.id,
      chapterId: evaluation.chapterId,
      score: evaluation.score,
      threshold: evaluation.threshold,
      status: evaluation.status,
      attemptNumber: evaluation.attemptNumber,
      errorsFromPreviousAttempts: evaluation.errorsFromPreviousAttempts,
      ...(evaluation.feedback && { feedback: evaluation.feedback }),
      evaluatedAt: evaluation.evaluatedAt,
      ...(evaluation.evaluationData && { evaluationData: evaluation.evaluationData }),
    };
  }
}
