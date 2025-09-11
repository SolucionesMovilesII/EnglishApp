import {
  Controller,
  Post,
  Get,
  Put,
  Param,
  Body,
  UseGuards,
  Request,
  Logger,
  HttpStatus,
  HttpCode,
  ValidationPipe,
  UsePipes,
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse, ApiBearerAuth, ApiParam } from '@nestjs/swagger';
import { ThrottlerGuard } from '@nestjs/throttler';
import { EnhancedJwtGuard } from '../../../shared/guards/enhanced-jwt.guard';
import { CreateProgressDto } from '../../../application/dtos/progress/create-progress.dto';
import { UpdateProgressDto } from '../../../application/dtos/progress/update-progress.dto';
import { ProgressResponseDto } from '../../../application/dtos/progress/progress-response.dto';
import { UserProgressListDto } from '../../../application/dtos/progress/user-progress-list.dto';
import { CreateProgressUseCase } from '../../../application/use-cases/progress/create-progress.use-case';
import { GetUserProgressUseCase } from '../../../application/use-cases/progress/get-user-progress.use-case';
import { UpdateProgressUseCase } from '../../../application/use-cases/progress/update-progress.use-case';

interface AuthenticatedRequest extends Request {
  user: {
    userId: string;
    email: string;
    role: string;
  };
}

@ApiTags('Progress')
@Controller('progress')
@UseGuards(ThrottlerGuard, EnhancedJwtGuard)
@ApiBearerAuth()
export class ProgressController {
  private readonly logger = new Logger(ProgressController.name);

  constructor(
    private readonly createProgressUseCase: CreateProgressUseCase,
    private readonly getUserProgressUseCase: GetUserProgressUseCase,
    private readonly updateProgressUseCase: UpdateProgressUseCase,
  ) {}

  @Post()
  @HttpCode(HttpStatus.CREATED)
  @UsePipes(new ValidationPipe({ whitelist: true, forbidNonWhitelisted: true }))
  @ApiOperation({
    summary: 'Create or update user progress',
    description: 'Creates a new progress record or updates existing one for the authenticated user',
  })
  @ApiResponse({
    status: 201,
    description: 'Progress created or updated successfully',
    type: ProgressResponseDto,
  })
  @ApiResponse({
    status: 400,
    description: 'Invalid input data',
  })
  @ApiResponse({
    status: 401,
    description: 'Unauthorized - Invalid or missing JWT token',
  })
  @ApiResponse({
    status: 404,
    description: 'User not found',
  })
  async createProgress(
    @Body() createProgressDto: CreateProgressDto,
    @Request() req: AuthenticatedRequest,
  ): Promise<ProgressResponseDto> {
    this.logger.log(`Creating progress for user: ${req.user.userId}`);

    try {
      return await this.createProgressUseCase.execute(req.user.userId, createProgressDto);
    } catch (error) {
      this.logger.error(
        `Error creating progress: ${error instanceof Error ? error.message : String(error)}`,
      );
      throw error;
    }
  }

  @Get(':userId')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Get user progress',
    description:
      'Retrieves all progress records for a user. Users can only access their own progress unless they are admin.',
  })
  @ApiParam({
    name: 'userId',
    description: 'User ID to get progress for',
    type: 'string',
    format: 'uuid',
  })
  @ApiResponse({
    status: 200,
    description: 'User progress retrieved successfully',
    type: UserProgressListDto,
  })
  @ApiResponse({
    status: 401,
    description: 'Unauthorized - Invalid or missing JWT token',
  })
  @ApiResponse({
    status: 403,
    description: "Forbidden - Cannot access other user's progress",
  })
  @ApiResponse({
    status: 404,
    description: 'User not found',
  })
  async getUserProgress(
    @Param('userId') targetUserId: string,
    @Request() req: AuthenticatedRequest,
  ): Promise<UserProgressListDto> {
    this.logger.log(`Getting progress for user: ${targetUserId}, requested by: ${req.user.userId}`);

    try {
      return await this.getUserProgressUseCase.execute(targetUserId, req.user.userId);
    } catch (error) {
      this.logger.error(
        `Error getting user progress: ${error instanceof Error ? error.message : String(error)}`,
      );
      throw error;
    }
  }

  @Put(':id')
  @HttpCode(HttpStatus.OK)
  @UsePipes(new ValidationPipe({ whitelist: true, forbidNonWhitelisted: true }))
  @ApiOperation({
    summary: 'Update progress record',
    description: 'Updates an existing progress record. Users can only update their own progress.',
  })
  @ApiParam({
    name: 'id',
    description: 'Progress record ID',
    type: 'string',
    format: 'uuid',
  })
  @ApiResponse({
    status: 200,
    description: 'Progress updated successfully',
    type: ProgressResponseDto,
  })
  @ApiResponse({
    status: 400,
    description: 'Invalid input data',
  })
  @ApiResponse({
    status: 401,
    description: 'Unauthorized - Invalid or missing JWT token',
  })
  @ApiResponse({
    status: 403,
    description: "Forbidden - Cannot update other user's progress",
  })
  @ApiResponse({
    status: 404,
    description: 'Progress record not found',
  })
  async updateProgress(
    @Param('id') progressId: string,
    @Body() updateProgressDto: UpdateProgressDto,
    @Request() req: AuthenticatedRequest,
  ): Promise<ProgressResponseDto> {
    this.logger.log(`Updating progress: ${progressId} by user: ${req.user.userId}`);

    try {
      return await this.updateProgressUseCase.execute(
        progressId,
        req.user.userId,
        updateProgressDto,
      );
    } catch (error) {
      this.logger.error(
        `Error updating progress: ${error instanceof Error ? error.message : String(error)}`,
      );
      throw error;
    }
  }
}
