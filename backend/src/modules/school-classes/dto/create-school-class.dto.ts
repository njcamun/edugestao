import { IsNotEmpty, IsString, IsOptional } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class CreateSchoolClassDto {
  @ApiProperty({ example: 'Turma A' })
  @IsString()
  @IsNotEmpty()
  name: string;

  @ApiProperty()
  @IsString()
  @IsNotEmpty()
  academicYearId: string;

  @ApiProperty()
  @IsString()
  @IsNotEmpty()
  gradeLevelId: string;

  @ApiProperty({ required: false })
  @IsString()
  @IsOptional()
  roomId?: string;
}
