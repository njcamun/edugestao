import { IsNotEmpty, IsString, IsBoolean, IsDateString, IsOptional } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class CreateAcademicYearDto {
  @ApiProperty({ example: '2025' })
  @IsString()
  @IsNotEmpty()
  year: string;

  @ApiProperty({ example: '2025-02-01' })
  @IsDateString()
  @IsNotEmpty()
  startDate: string;

  @ApiProperty({ example: '2025-12-15' })
  @IsDateString()
  @IsNotEmpty()
  endDate: string;

  @ApiProperty({ required: false, default: true })
  @IsBoolean()
  @IsOptional()
  isActive?: boolean;
}
