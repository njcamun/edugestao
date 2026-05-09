import { IsNotEmpty, IsString, IsNumber, Min, Max, IsOptional } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class CreateGradeDto {
  @ApiProperty()
  @IsString()
  @IsNotEmpty()
  enrollmentId!: string;

  @ApiProperty()
  @IsString()
  @IsNotEmpty()
  subjectId!: string;

  @ApiProperty({ example: 1 })
  @IsNumber()
  @Min(1)
  @Max(3)
  trimester!: number;

  @ApiProperty({ example: 'Teste' })
  @IsString()
  @IsNotEmpty()
  type!: string;

  @ApiProperty({ example: 14.5 })
  @IsNumber()
  @Min(0)
  @Max(20)
  value!: number;

  @ApiProperty({ required: false, default: 1.0 })
  @IsNumber()
  @IsOptional()
  weight?: number;
}
