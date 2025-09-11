# Node.js Backend Rules and Standards - Clean Architecture

## Project Overview

This document establishes the comprehensive coding standards, architectural patterns, and development rules for Node.js backend applications supporting the Idiomas App ecosystem. These standards ensure maintainable, scalable, and production-ready APIs following Clean Architecture principles with strict TypeScript implementation and TypeORM database management.

## 1. Architecture & Project Structure

### 1.1 Clean Architecture Implementation

The project follows **Clean Architecture** principles with clear separation of concerns:

```
src/
├── application/              # Application layer (Use cases/Business logic)
│   ├── dtos/                # Data Transfer Objects
│   ├── interfaces/          # Repository and service interfaces
│   ├── services/            # Application services
│   └── use-cases/           # Business use cases
├── domain/                  # Domain layer (Entities and business rules)
│   ├── entities/            # Domain entities
│   ├── enums/              # Domain enumerations
│   ├── errors/             # Domain-specific errors
│   └── value-objects/      # Value objects
├── infrastructure/          # Infrastructure layer (External concerns)
│   ├── database/           # Database configuration and migrations
│   │   ├── migrations/     # TypeORM migrations
│   │   ├── seeders/        # Database seeders
│   │   └── data-source.ts  # TypeORM DataSource configuration
│   ├── repositories/       # Repository implementations
│   ├── external-services/  # Third-party service integrations
│   └── config/             # Configuration files
├── presentation/            # Presentation layer (Controllers and routes)
│   ├── controllers/        # Route controllers
│   ├── middlewares/        # Express middlewares
│   ├── routes/             # Route definitions
│   └── validators/         # Request validation schemas
├── shared/                  # Shared utilities and constants
│   ├── constants/          # Application constants
│   ├── decorators/         # Custom decorators
│   ├── types/              # TypeScript type definitions
│   └── utils/              # Utility functions
└── main.ts                 # Application entry point
```

**Rules:**
- **Maximum folder depth**: 3 levels (e.g., `src/infrastructure/database/migrations/`)
- **Single responsibility**: Each folder serves one clear architectural purpose
- **Dependency direction**: Dependencies flow inward (Infrastructure → Application → Domain)
- **No circular dependencies**: Strict enforcement of dependency rules

### 1.2 User ID Naming Convention (STANDARD)

**MANDATORY: We use `id` for all user identifiers throughout the application**

- **Database column**: `id` (UUID type)
- **Method parameters**: `id: string`
- **Variable names**: `userId` only when referring to another entity's user reference
- **API endpoints**: `/users/:id`
- **JWT payload**: `sub` field contains the user ID
- **Response DTOs**: `id` field for user identifier

### 1.3 File Organization Principles

**File Naming Convention:**
- **kebab-case** for all file names: `user-controller.ts`, `user-repository.ts`
- **PascalCase** for class names: `UserController`, `UserRepository`
- **camelCase** for variables and methods: `isActive`, `getUserById()`
- **UPPERCASE** for constants: `DATABASE_URL`, `JWT_SECRET`

**File Size Limitations:**
- **MAXIMUM 400 lines** per file (STRICTLY ENFORCED)
- Split large files into smaller, focused modules
- Create separate files for related functionality

**File Suffixes:**
- Controllers: `*.controller.ts`
- Services: `*.service.ts`
- Repositories: `*.repository.ts`
- Entities: `*.entity.ts`
- DTOs: `*.dto.ts`
- Types: `*.types.ts`
- Interfaces: `*.interface.ts`

## 2. TypeScript Configuration (STRICT TYPING)

### 2.1 tsconfig.json (Required)

**MANDATORY strict TypeScript configuration:**

```json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "commonjs",
    "lib": ["ES2022"],
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "noImplicitAny": true,
    "strictNullChecks": true,
    "strictFunctionTypes": true,
    "noImplicitReturns": true,
    "noImplicitThis": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "exactOptionalPropertyTypes": true,
    "allowSyntheticDefaultImports": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true,
    "experimentalDecorators": true,
    "emitDecoratorMetadata": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist"]
}
```

### 2.2 Strict Typing Rules

**PROHIBITED:**
```typescript
// ❌ NEVER use 'any' type
function processData(data: any): any {
  return data;
}

// ❌ NEVER use non-null assertion without proper checks
user!.email
```

**REQUIRED:**
```typescript
// ✅ ALWAYS use proper typing
interface User {
  readonly id: string;
  email: string;
  name: string;
  createdAt: Date;
  updatedAt: Date;
}

function processUser(user: User): UserResponseDto {
  return {
    id: user.id,
    email: user.email,
    name: user.name,
  };
}

// ✅ ALWAYS handle nullable values properly
const getUserEmail = (user: User | null): string | null => {
  return user?.email ?? null;
};
```

**Type Definition Standards:**
- **Interfaces**: For object structures and contracts
- **Types**: For unions, intersections, and computed types
- **Enums**: For fixed sets of values
- **Generic types**: For reusable type definitions

## 3. TypeORM Integration & Database Management

### 3.1 TypeORM Configuration (Required)

**DataSource configuration (`src/infrastructure/database/data-source.ts`):**

```typescript
import { DataSource } from 'typeorm';
import { config } from '../config/database.config';

export const AppDataSource = new DataSource({
  type: 'postgres',
  host: config.database.host,
  port: config.database.port,
  username: config.database.username,
  password: config.database.password,
  database: config.database.name,
  synchronize: false, // ALWAYS false in production
  logging: config.app.nodeEnv === 'development',
  entities: ['src/domain/entities/*.entity{.ts,.js}'],
  migrations: ['src/infrastructure/database/migrations/*{.ts,.js}'],
  subscribers: ['src/infrastructure/database/subscribers/*{.ts,.js}'],
});
```

### 3.2 Entity Definition Standards

**Entity structure (`src/domain/entities/*.entity.ts`):**

```typescript
import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  Index,
} from 'typeorm';

@Entity('users')
@Index(['email'], { unique: true })
export class User {
  @PrimaryGeneratedColumn('uuid')
  readonly id!: string;

  @Column({ type: 'varchar', length: 255, unique: true })
  email!: string;

  @Column({ type: 'varchar', length: 100 })
  name!: string;

  @Column({ type: 'varchar', length: 255, select: false })
  password!: string;

  @Column({ type: 'boolean', default: true })
  isActive!: boolean;

  @CreateDateColumn({ type: 'timestamptz' })
  readonly createdAt!: Date;

  @UpdateDateColumn({ type: 'timestamptz' })
  readonly updatedAt!: Date;
}
```

**Entity Rules:**
- **UUID primary keys**: Always use UUID for primary keys
- **Explicit column types**: Define specific PostgreSQL types
- **Readonly fields**: Mark auto-generated fields as readonly
- **Proper indexing**: Add indexes for frequently queried fields
- **Timestamps**: Include createdAt and updatedAt for all entities

### 3.3 Migration Management (MANDATORY)

**Migration generation and execution:**

```bash
# Generate migration (REQUIRED for all schema changes)
npm run migration:generate -- src/infrastructure/database/migrations/CreateUserTable

# Run migrations (preserves existing data)
npm run migration:run

# Revert migration (only if necessary)
npm run migration:revert

# Show migration status
npm run migration:show
```

**Migration structure:**
```typescript
import { MigrationInterface, QueryRunner, Table, Index } from 'typeorm';

export class CreateUserTable1703001001000 implements MigrationInterface {
  name = 'CreateUserTable1703001001000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.createTable(
      new Table({
        name: 'users',
        columns: [
          {
            name: 'id',
            type: 'uuid',
            isPrimary: true,
            generationStrategy: 'uuid',
            default: 'uuid_generate_v4()',
          },
          {
            name: 'email',
            type: 'varchar',
            length: '255',
            isUnique: true,
          },
          // ... other columns
        ],
      }),
    );

    await queryRunner.createIndex(
      'users',
      new Index('IDX_USERS_EMAIL', ['email']),
    );
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.dropTable('users');
  }
}
```

**Migration Rules:**
- **ALWAYS generate migrations**: Never modify database manually
- **Preserve data**: Migrations must maintain existing data integrity
- **Incremental changes**: One logical change per migration
- **Rollback support**: Implement proper down() methods

## 4. Repository Pattern Implementation

### 4.1 Repository Interface Definition

**Repository interface (`src/application/interfaces/user-repository.interface.ts`):**

```typescript
import { User } from '../../domain/entities/user.entity';
import { CreateUserDto } from '../dtos/create-user.dto';
import { UpdateUserDto } from '../dtos/update-user.dto';

export interface IUserRepository {
  create(createUserDto: CreateUserDto): Promise<User>;
  findById(id: string): Promise<User | null>;
  findByEmail(email: string): Promise<User | null>;
  findAll(page: number, limit: number): Promise<[User[], number]>;
  update(id: string, updateUserDto: UpdateUserDto): Promise<User | null>;
  delete(id: string): Promise<boolean>;
  exists(id: string): Promise<boolean>;
}
```

### 4.2 Repository Implementation

**Repository implementation (`src/infrastructure/repositories/user.repository.ts`):**

```typescript
import { Repository } from 'typeorm';
import { Injectable } from '@nestjs/common'; // If using NestJS decorators
import { AppDataSource } from '../database/data-source';
import { User } from '../../domain/entities/user.entity';
import { IUserRepository } from '../../application/interfaces/user-repository.interface';
import { CreateUserDto } from '../../application/dtos/create-user.dto';
import { UpdateUserDto } from '../../application/dtos/update-user.dto';

@Injectable()
export class UserRepository implements IUserRepository {
  private readonly repository: Repository<User>;

  constructor() {
    this.repository = AppDataSource.getRepository(User);
  }

  async create(createUserDto: CreateUserDto): Promise<User> {
    const user = this.repository.create(createUserDto);
    return await this.repository.save(user);
  }

  async findById(id: string): Promise<User | null> {
    return await this.repository.findOne({ where: { id } });
  }

  async findByEmail(email: string): Promise<User | null> {
    return await this.repository.findOne({ where: { email } });
  }

  async findAll(page: number, limit: number): Promise<[User[], number]> {
    return await this.repository.findAndCount({
      skip: (page - 1) * limit,
      take: limit,
      order: { createdAt: 'DESC' },
    });
  }

  async update(id: string, updateUserDto: UpdateUserDto): Promise<User | null> {
    const result = await this.repository.update(id, updateUserDto);
    if (result.affected === 0) {
      return null;
    }
    return await this.findById(id);
  }

  async delete(id: string): Promise<boolean> {
    const result = await this.repository.delete(id);
    return result.affected !== 0;
  }

  async exists(id: string): Promise<boolean> {
    const count = await this.repository.count({ where: { id } });
    return count > 0;
  }
}
```

## 5. Service Layer & Use Cases

### 5.1 Service Layer Structure

**Application service (`src/application/services/user.service.ts`):**

```typescript
import { Injectable, NotFoundException, ConflictException } from '@nestjs/common';
import { IUserRepository } from '../interfaces/user-repository.interface';
import { CreateUserDto } from '../dtos/create-user.dto';
import { UpdateUserDto } from '../dtos/update-user.dto';
import { UserResponseDto } from '../dtos/user-response.dto';
import { HashingService } from '../../shared/services/hashing.service';

@Injectable()
export class UserService {
  constructor(
    private readonly userRepository: IUserRepository,
    private readonly hashingService: HashingService,
  ) {}

  async createUser(createUserDto: CreateUserDto): Promise<UserResponseDto> {
    // Check if user already exists
    const existingUser = await this.userRepository.findByEmail(createUserDto.email);
    if (existingUser) {
      throw new ConflictException('User with this email already exists');
    }

    // Hash password
    const hashedPassword = await this.hashingService.hash(createUserDto.password);

    // Create user
    const user = await this.userRepository.create({
      ...createUserDto,
      password: hashedPassword,
    });

    return this.mapToResponseDto(user);
  }

  async getUserById(id: string): Promise<UserResponseDto> {
    const user = await this.userRepository.findById(id);
    if (!user) {
      throw new NotFoundException(`User with ID ${id} not found`);
    }

    return this.mapToResponseDto(user);
  }

  async updateUser(id: string, updateUserDto: UpdateUserDto): Promise<UserResponseDto> {
    const user = await this.userRepository.update(id, updateUserDto);
    if (!user) {
      throw new NotFoundException(`User with ID ${id} not found`);
    }

    return this.mapToResponseDto(user);
  }

  async deleteUser(id: string): Promise<void> {
    const deleted = await this.userRepository.delete(id);
    if (!deleted) {
      throw new NotFoundException(`User with ID ${id} not found`);
    }
  }

  private mapToResponseDto(user: User): UserResponseDto {
    return {
      id: user.id,
      email: user.email,
      name: user.name,
      isActive: user.isActive,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
    };
  }
}
```

### 5.2 Use Case Implementation

**Use case structure (`src/application/use-cases/create-user.use-case.ts`):**

```typescript
import { Injectable } from '@nestjs/common';
import { UserService } from '../services/user.service';
import { CreateUserDto } from '../dtos/create-user.dto';
import { UserResponseDto } from '../dtos/user-response.dto';

@Injectable()
export class CreateUserUseCase {
  constructor(private readonly userService: UserService) {}

  async execute(createUserDto: CreateUserDto): Promise<UserResponseDto> {
    // Business logic validation
    this.validateBusinessRules(createUserDto);

    // Execute the creation
    return await this.userService.createUser(createUserDto);
  }

  private validateBusinessRules(createUserDto: CreateUserDto): void {
    // Domain-specific validation logic
    if (createUserDto.name.trim().length < 2) {
      throw new Error('Name must be at least 2 characters long');
    }

    if (!this.isValidEmail(createUserDto.email)) {
      throw new Error('Invalid email format');
    }
  }

  private isValidEmail(email: string): boolean {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
  }
}
```

## 6. Controller Layer & API Design

### 6.1 Controller Structure

**Controller implementation (`src/presentation/controllers/user.controller.ts`):**

```typescript
import {
  Controller,
  Get,
  Post,
  Put,
  Delete,
  Body,
  Param,
  Query,
  HttpStatus,
  HttpCode,
  UseGuards,
  UsePipes,
  ValidationPipe,
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse, ApiBearerAuth } from '@nestjs/swagger';
import { CreateUserUseCase } from '../../application/use-cases/create-user.use-case';
import { GetUserUseCase } from '../../application/use-cases/get-user.use-case';
import { CreateUserDto } from '../../application/dtos/create-user.dto';
import { UpdateUserDto } from '../../application/dtos/update-user.dto';
import { UserResponseDto } from '../../application/dtos/user-response.dto';
import { JwtAuthGuard } from '../guards/jwt-auth.guard';
import { UuidValidationPipe } from '../pipes/uuid-validation.pipe';

@ApiTags('users')
@Controller('users')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
export class UserController {
  constructor(
    private readonly createUserUseCase: CreateUserUseCase,
    private readonly getUserUseCase: GetUserUseCase,
  ) {}

  @Post()
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({ summary: 'Create a new user' })
  @ApiResponse({
    status: 201,
    description: 'User successfully created',
    type: UserResponseDto,
  })
  @ApiResponse({ status: 400, description: 'Bad request' })
  @ApiResponse({ status: 409, description: 'User already exists' })
  @UsePipes(new ValidationPipe({ whitelist: true, forbidNonWhitelisted: true }))
  async createUser(@Body() createUserDto: CreateUserDto): Promise<UserResponseDto> {
    return await this.createUserUseCase.execute(createUserDto);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get user by ID' })
  @ApiResponse({
    status: 200,
    description: 'User found',
    type: UserResponseDto,
  })
  @ApiResponse({ status: 404, description: 'User not found' })
  async getUserById(
    @Param('id', UuidValidationPipe) id: string,
  ): Promise<UserResponseDto> {
    return await this.getUserUseCase.execute(id);
  }

  @Get()
  @ApiOperation({ summary: 'Get all users with pagination' })
  async getAllUsers(
    @Query('page') page: number = 1,
    @Query('limit') limit: number = 10,
  ): Promise<{
    data: UserResponseDto[];
    total: number;
    page: number;
    limit: number;
  }> {
    return await this.getUserUseCase.executeGetAll(page, limit);
  }
}
```

### 6.2 DTO Definitions

**Create User DTO (`src/application/dtos/create-user.dto.ts`):**

```typescript
import {
  IsEmail,
  IsString,
  MinLength,
  MaxLength,
  IsNotEmpty,
  IsOptional,
  Matches,
} from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class CreateUserDto {
  @ApiProperty({
    description: 'User email address',
    example: 'user@example.com',
  })
  @IsEmail({}, { message: 'Please provide a valid email address' })
  @IsNotEmpty({ message: 'Email is required' })
  readonly email!: string;

  @ApiProperty({
    description: 'User full name',
    example: 'John Doe',
    minLength: 2,
    maxLength: 100,
  })
  @IsString({ message: 'Name must be a string' })
  @IsNotEmpty({ message: 'Name is required' })
  @MinLength(2, { message: 'Name must be at least 2 characters long' })
  @MaxLength(100, { message: 'Name must not exceed 100 characters' })
  readonly name!: string;

  @ApiProperty({
    description: 'User password',
    example: 'SecurePass123!',
    minLength: 8,
  })
  @IsString({ message: 'Password must be a string' })
  @IsNotEmpty({ message: 'Password is required' })
  @MinLength(8, { message: 'Password must be at least 8 characters long' })
  @Matches(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]/, {
    message: 'Password must contain at least one uppercase letter, one lowercase letter, one number and one special character',
  })
  readonly password!: string;
}
```

**Response DTO (`src/application/dtos/user-response.dto.ts`):**

```typescript
import { ApiProperty } from '@nestjs/swagger';

export class UserResponseDto {
  @ApiProperty({ description: 'User unique identifier' })
  readonly id!: string;

  @ApiProperty({ description: 'User email address' })
  readonly email!: string;

  @ApiProperty({ description: 'User full name' })
  readonly name!: string;

  @ApiProperty({ description: 'User active status' })
  readonly isActive!: boolean;

  @ApiProperty({ description: 'User creation timestamp' })
  readonly createdAt!: Date;

  @ApiProperty({ description: 'User last update timestamp' })
  readonly updatedAt!: Date;
}
```

## 7. Error Handling & Validation

### 7.1 Global Exception Filter

**Exception filter (`src/shared/filters/global-exception.filter.ts`):**

```typescript
import {
  ExceptionFilter,
  Catch,
  ArgumentsHost,
  HttpException,
  HttpStatus,
  Logger,
} from '@nestjs/common';
import { Request, Response } from 'express';
import { QueryFailedError } from 'typeorm';

@Catch()
export class GlobalExceptionFilter implements ExceptionFilter {
  private readonly logger = new Logger(GlobalExceptionFilter.name);

  catch(exception: unknown, host: ArgumentsHost): void {
    const ctx = host.switchToHttp();
    const response = ctx.getResponse<Response>();
    const request = ctx.getRequest<Request>();

    let status: number;
    let message: string;
    let details: any = null;

    if (exception instanceof HttpException) {
      status = exception.getStatus();
      const exceptionResponse = exception.getResponse();
      message = typeof exceptionResponse === 'string' 
        ? exceptionResponse 
        : (exceptionResponse as any).message;
      details = typeof exceptionResponse === 'object' ? exceptionResponse : null;
    } else if (exception instanceof QueryFailedError) {
      status = HttpStatus.BAD_REQUEST;
      message = 'Database operation failed';
      details = { error: exception.message };
    } else {
      status = HttpStatus.INTERNAL_SERVER_ERROR;
      message = 'Internal server error';
    }

    const errorResponse = {
      statusCode: status,
      timestamp: new Date().toISOString(),
      path: request.url,
      method: request.method,
      message,
      ...(details && { details }),
    };

    this.logger.error(
      `${request.method} ${request.url} - ${status} - ${message}`,
      exception instanceof Error ? exception.stack : exception,
    );

    response.status(status).json(errorResponse);
  }
}
```

### 7.2 Custom Domain Exceptions

**Domain exceptions (`src/domain/errors/domain.errors.ts`):**

```typescript
export abstract class DomainError extends Error {
  abstract readonly code: string;
  abstract readonly statusCode: number;

  constructor(message: string) {
    super(message);
    this.name = this.constructor.name;
    Error.captureStackTrace(this, this.constructor);
  }
}

export class UserNotFoundError extends DomainError {
  readonly code = 'USER_NOT_FOUND';
  readonly statusCode = 404;

  constructor(id: string) {
    super(`User with ID ${id} was not found`);
  }
}

export class UserAlreadyExistsError extends DomainError {
  readonly code = 'USER_ALREADY_EXISTS';
  readonly statusCode = 409;

  constructor(email: string) {
    super(`User with email ${email} already exists`);
  }
}

export class InvalidCredentialsError extends DomainError {
  readonly code = 'INVALID_CREDENTIALS';
  readonly statusCode = 401;

  constructor() {
    super('Invalid email or password');
  }
}
```

## 8. Security Implementation

### 8.1 Authentication & Authorization

**JWT Strategy (`src/infrastructure/auth/jwt.strategy.ts`):**

```typescript
import { Injectable, UnauthorizedException } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { ExtractJwt, Strategy } from 'passport-jwt';
import { ConfigService } from '@nestjs/config';
import { IUserRepository } from '../../application/interfaces/user-repository.interface';

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  constructor(
    private readonly configService: ConfigService,
    private readonly userRepository: IUserRepository,
  ) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: configService.get<string>('JWT_SECRET'),
    });
  }

  async validate(payload: { sub: string; email: string }): Promise<any> {
    const user = await this.userRepository.findById(payload.sub);
    if (!user || !user.isActive) {
      throw new UnauthorizedException('User not found or inactive');
    }

    return {
      id: user.id,
      email: user.email,
      name: user.name,
    };
  }
}
```

### 8.2 Password Hashing Service

**Hashing service (`src/shared/services/hashing.service.ts`):**

```typescript
import { Injectable } from '@nestjs/common';
import * as bcrypt from 'bcrypt';

@Injectable()
export class HashingService {
  private readonly saltRounds = 12;

  async hash(password: string): Promise<string> {
    return await bcrypt.hash(password, this.saltRounds);
  }

  async compare(password: string, hash: string): Promise<boolean> {
    return await bcrypt.compare(password, hash);
  }
}
```

## 9. Configuration Management

### 9.1 Environment Configuration

**Configuration service (`src/infrastructure/config/configuration.ts`):**

```typescript
import { registerAs } from '@nestjs/config';

export interface DatabaseConfig {
  host: string;
  port: number;
  username: string;
  password: string;
  name: string;
  ssl: boolean;
}

export interface AppConfig {
  nodeEnv: 'development' | 'production' | 'test';
  port: number;
  apiPrefix: string;
  jwtSecret: string;
  jwtExpiresIn: string;
}

export const databaseConfig = registerAs('database', (): DatabaseConfig => ({
  host: process.env.DATABASE_HOST || 'localhost',
  port: parseInt(process.env.DATABASE_PORT || '5432', 10),
  username: process.env.DATABASE_USERNAME || 'postgres',
  password: process.env.DATABASE_PASSWORD || 'password',
  name: process.env.DATABASE_NAME || 'idiomas_app',
  ssl: process.env.DATABASE_SSL === 'true',
}));

export const appConfig = registerAs('app', (): AppConfig => ({
  nodeEnv: (process.env.NODE_ENV as 'development' | 'production' | 'test') || 'development',
  port: parseInt(process.env.PORT || '3000', 10),
  apiPrefix: process.env.API_PREFIX || 'api/v1',
  jwtSecret: process.env.JWT_SECRET || 'your-secret-key',
  jwtExpiresIn: process.env.JWT_EXPIRES_IN || '1d',
}));
```

### 9.2 Environment Variables

**Required environment variables (`.env`):**

```env
# Application
NODE_ENV=development
PORT=3000
API_PREFIX=api/v1

# Database
DATABASE_HOST=localhost
DATABASE_PORT=5432
DATABASE_USERNAME=postgres
DATABASE_PASSWORD=your_password
DATABASE_NAME=idiomas_app_backend
DATABASE_SSL=false

# JWT
JWT_SECRET=your-super-secret-jwt-key-here
JWT_EXPIRES_IN=1d

# External Services
GOOGLE_CLIENT_ID=your-google-client-id
APPLE_TEAM_ID=your-apple-team-id
```

## 10. Testing Standards

### 10.1 Unit Testing

**Service unit test (`src/application/services/__tests__/user.service.spec.ts`):**

```typescript
import { Test, TestingModule } from '@nestjs/testing';
import { UserService } from '../user.service';
import { IUserRepository } from '../../interfaces/user-repository.interface';
import { HashingService } from '../../../shared/services/hashing.service';
import { CreateUserDto } from '../../dtos/create-user.dto';
import { ConflictException, NotFoundException } from '@nestjs/common';
import { User } from '../../../domain/entities/user.entity';

describe('UserService', () => {
  let service: UserService;
  let userRepository: jest.Mocked<IUserRepository>;
  let hashingService: jest.Mocked<HashingService>;

  const mockUser: User = {
    id: '123e4567-e89b-12d3-a456-426614174000',
    email: 'test@example.com',
    name: 'Test User',
    password: 'hashedPassword',
    isActive: true,
    createdAt: new Date(),
    updatedAt: new Date(),
  } as User;

  beforeEach(async () => {
    const mockUserRepository = {
      create: jest.fn(),
      findById: jest.fn(),
      findByEmail: jest.fn(),
      update: jest.fn(),
      delete: jest.fn(),
    };

    const mockHashingService = {
      hash: jest.fn(),
      compare: jest.fn(),
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        UserService,
        { provide: 'IUserRepository', useValue: mockUserRepository },
        { provide: HashingService, useValue: mockHashingService },
      ],
    }).compile();

    service = module.get<UserService>(UserService);
    userRepository = module.get('IUserRepository');
    hashingService = module.get(HashingService);
  });

  describe('createUser', () => {
    it('should create a user successfully', async () => {
      const createUserDto: CreateUserDto = {
        email: 'test@example.com',
        name: 'Test User',
        password: 'password123',
      };

      userRepository.findByEmail.mockResolvedValue(null);
      hashingService.hash.mockResolvedValue('hashedPassword');
      userRepository.create.mockResolvedValue(mockUser);

      const result = await service.createUser(createUserDto);

      expect(result).toEqual({
        id: mockUser.id,
        email: mockUser.email,
        name: mockUser.name,
        isActive: mockUser.isActive,
        createdAt: mockUser.createdAt,
        updatedAt: mockUser.updatedAt,
      });
      expect(userRepository.findByEmail).toHaveBeenCalledWith(createUserDto.email);
      expect(hashingService.hash).toHaveBeenCalledWith(createUserDto.password);
      expect(userRepository.create).toHaveBeenCalledWith({
        ...createUserDto,
        password: 'hashedPassword',
      });
    });

    it('should throw ConflictException if user already exists', async () => {
      const createUserDto: CreateUserDto = {
        email: 'test@example.com',
        name: 'Test User',
        password: 'password123',
      };

      userRepository.findByEmail.mockResolvedValue(mockUser);

      await expect(service.createUser(createUserDto)).rejects.toThrow(
        ConflictException,
      );
      expect(userRepository.findByEmail).toHaveBeenCalledWith(createUserDto.email);
      expect(userRepository.create).not.toHaveBeenCalled();
    });
  });
});
```

### 10.2 Integration Testing

**Controller integration test (`src/presentation/controllers/__tests__/user.controller.integration.spec.ts`):**

```typescript
import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication } from '@nestjs/common';
import * as request from 'supertest';
import { AppModule } from '../../../app.module';
import { AppDataSource } from '../../../infrastructure/database/data-source';

describe('UserController (Integration)', () => {
  let app: INestApplication;

  beforeAll(async () => {
    const moduleFixture: TestingModule = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();

    app = moduleFixture.createNestApplication();
    await app.init();

    // Initialize test database
    await AppDataSource.initialize();
    await AppDataSource.runMigrations();
  });

  afterAll(async () => {
    await AppDataSource.destroy();
    await app.close();
  });

  describe('/users (POST)', () => {
    it('should create a new user', () => {
      return request(app.getHttpServer())
        .post('/users')
        .send({
          email: 'integration@test.com',
          name: 'Integration Test',
          password: 'SecurePass123!',
        })
        .expect(201)
        .expect((res) => {
          expect(res.body).toHaveProperty('id');
          expect(res.body).toHaveProperty('email', 'integration@test.com');
          expect(res.body).toHaveProperty('name', 'Integration Test');
          expect(res.body).not.toHaveProperty('password');
        });
    });

    it('should return 400 for invalid email', () => {
      return request(app.getHttpServer())
        .post('/users')
        .send({
          email: 'invalid-email',
          name: 'Test User',
          password: 'SecurePass123!',
        })
        .expect(400);
    });
  });
});
```

## 11. Package.json Scripts & Dependencies

### 11.1 Required Dependencies

```json
{
  "name": "idiomas-app-backend",
  "version": "1.0.0",
  "description": "Backend API for Idiomas App",
  "scripts": {
    "build": "tsc",
    "start": "node dist/main.js",
    "start:dev": "nodemon --exec ts-node src/main.ts",
    "start:debug": "nodemon --exec ts-node --inspect src/main.ts",
    "lint": "eslint src/**/*.ts --fix",
    "lint:check": "eslint src/**/*.ts",
    "format": "prettier --write \"src/**/*.ts\"",
    "format:check": "prettier --check \"src/**/*.ts\"",
    "test": "jest",
    "test:watch": "jest --watch",
    "test:cov": "jest --coverage",
    "test:e2e": "jest --config ./test/jest-e2e.json",
    "migration:generate": "typeorm-ts-node-commonjs migration:generate -d src/infrastructure/database/data-source.ts",
    "migration:run": "typeorm-ts-node-commonjs migration:run -d src/infrastructure/database/data-source.ts",
    "migration:revert": "typeorm-ts-node-commonjs migration:revert -d src/infrastructure/database/data-source.ts",
    "migration:show": "typeorm-ts-node-commonjs migration:show -d src/infrastructure/database/data-source.ts",
    "schema:sync": "typeorm-ts-node-commonjs schema:sync -d src/infrastructure/database/data-source.ts",
    "seed": "ts-node src/infrastructure/database/seeders/index.ts"
  },
  "dependencies": {
    "@nestjs/common": "^10.0.0",
    "@nestjs/core": "^10.0.0",
    "@nestjs/config": "^3.0.0",
    "@nestjs/swagger": "^7.0.0",
    "@nestjs/jwt": "^10.0.0",
    "@nestjs/passport": "^10.0.0",
    "class-validator": "^0.14.0",
    "class-transformer": "^0.5.1",
    "passport": "^0.6.0",
    "passport-jwt": "^4.0.1",
    "passport-local": "^1.0.0",
    "bcrypt": "^5.1.0",
    "typeorm": "^0.3.17",
    "pg": "^8.11.0",
    "reflect-metadata": "^0.1.13",
    "uuid": "^9.0.0"
  },
  "devDependencies": {
    "@types/bcrypt": "^5.0.0",
    "@types/jest": "^29.5.0",
    "@types/node": "^20.0.0",
    "@types/passport-jwt": "^3.0.9",
    "@types/passport-local": "^1.0.35",
    "@types/pg": "^8.10.0",
    "@types/supertest": "^2.0.12",
    "@types/uuid": "^9.0.0",
    "@typescript-eslint/eslint-plugin": "^6.0.0",
    "@typescript-eslint/parser": "^6.0.0",
    "eslint": "^8.42.0",
    "eslint-config-prettier": "^8.8.0",
    "eslint-plugin-prettier": "^4.2.1",
    "jest": "^29.5.0",
    "nodemon": "^3.0.0",
    "prettier": "^2.8.8",
    "supertest": "^6.3.0",
    "ts-jest": "^29.1.0",
    "ts-node": "^10.9.0",
    "typescript": "^5.1.3"
  }
}
```

### 11.2 Development Scripts

**Essential scripts for development workflow:**

```bash
# Development
npm run start:dev          # Start development server with hot reload
npm run start:debug        # Start with debugging enabled

# Code quality
npm run lint               # Fix linting issues
npm run lint:check         # Check linting without fixing
npm run format             # Format code with Prettier
npm run format:check       # Check formatting without fixing

# Testing
npm run test               # Run unit tests
npm run test:watch         # Run tests in watch mode
npm run test:cov           # Run tests with coverage
npm run test:e2e           # Run end-to-end tests

# Database operations
npm run migration:generate -- CreateUserTable  # Generate migration
npm run migration:run      # Apply migrations
npm run migration:revert   # Revert last migration
npm run migration:show     # Show migration status

# Production
npm run build              # Build for production
npm start                  # Start production server
```

## 12. Development Workflow

### 12.1 Pre-commit Requirements (MANDATORY)

**MUST pass before every commit:**

```bash
# 1. Linting (MUST pass)
npm run lint:check

# 2. Type checking (MUST pass)
npm run build

# 3. Unit tests (MUST pass)
npm run test

# 4. Format check (MUST pass)
npm run format:check
```

### 12.2 Code Review Checklist

**Required checks for all code:**

- ✅ **TypeScript strict mode**: No `any` types used
- ✅ **File size limit**: All files under 400 lines
- ✅ **Architecture compliance**: Follows Clean Architecture layers
- ✅ **Database migrations**: All schema changes have migrations
- ✅ **Error handling**: Proper error handling implemented
- ✅ **Testing**: Unit tests written for business logic
- ✅ **Documentation**: Complex logic documented
- ✅ **Security**: No secrets in code, proper validation

### 12.3 Git Workflow

**Commit message format:**
```
type(scope): description

feat(auth): add JWT authentication middleware
fix(users): resolve password hashing issue
docs(readme): update installation instructions
refactor(services): extract common validation logic
test(users): add integration tests for user creation
```

**Branch naming convention:**
```
feature/add-user-authentication
bugfix/fix-password-validation
hotfix/security-vulnerability-patch
refactor/clean-architecture-migration
```

## 13. Production Deployment

### 13.1 Production Environment

**Production configuration checklist:**

- ✅ **Environment variables**: All secrets in environment variables
- ✅ **Database migrations**: Run migrations before deployment
- ✅ **SSL/TLS**: HTTPS enabled for all endpoints
- ✅ **Rate limiting**: API rate limiting configured
- ✅ **Logging**: Proper logging for production monitoring
- ✅ **Health checks**: Health check endpoints implemented
- ✅ **Error monitoring**: Error tracking service integrated

### 13.2 Docker Configuration

**Dockerfile:**
```dockerfile
FROM node:18-alpine AS builder

WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production && npm cache clean --force

FROM node:18-alpine AS runtime

WORKDIR /app
COPY --from=builder /app/node_modules ./node_modules
COPY . .

RUN npm run build

EXPOSE 3000

USER node

CMD ["npm", "start"]
```

**docker-compose.yml:**
```yaml
version: '3.8'

services:
  app:
    build: .
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
      - DATABASE_HOST=db
    depends_on:
      - db
      - redis

  db:
    image: postgres:15-alpine
    environment:
      - POSTGRES_DB=idiomas_app_backend
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=secure_password
    volumes:
      - postgres_data:/var/lib/postgresql/data

  redis:
    image: redis:7-alpine

volumes:
  postgres_data:
```

## Summary

These standards ensure that all Node.js backend projects maintain:

- **Clean Architecture** with clear separation of concerns
- **Strict TypeScript** implementation with zero tolerance for `any` types
- **TypeORM integration** with proper migration management
- **Maximum 400 lines** per file for maintainability
- **Comprehensive testing** strategy (unit, integration, e2e)
- **Security best practices** for authentication and data protection
- **Database migration workflow** preserving existing data
- **Production-ready deployment** configuration
- **Quality assurance processes** with automated checks
- **Performance optimization** for scalable applications

Following these standards guarantees maintainable, scalable, and production-ready Node.js backend applications that seamlessly integrate with Flutter frontend applications while maintaining clean architecture principles and strict coding standards.