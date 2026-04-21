import { Controller, Get, Post, Body, Param, Query, Patch, Delete, UseGuards } from '@nestjs/common';
import { ApiTags, ApiBearerAuth, ApiOperation, ApiQuery } from '@nestjs/swagger';
import { GradesService } from './grades.service';
import { CreateGradeDto } from './dto/create-grade.dto';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { RolesGuard } from '../../common/roles.guard';
import { Roles } from '../../common/roles.decorator';

@ApiTags('grades')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Controller('grades')
export class GradesController {
  constructor(private readonly service: GradesService) {}

  @Post()
  @Roles('ADMIN', 'PROFESSOR', 'SECRETARIA')
  @ApiOperation({ summary: 'Lançar uma nota' })
  create(@Body() dto: CreateGradeDto) {
    return this.service.create(dto);
  }

  @Get('enrollment/:enrollmentId')
  @ApiOperation({ summary: 'Listar notas de uma matrícula' })
  findByEnrollment(@Param('enrollmentId') enrollmentId: string) {
    return this.service.findByEnrollment(enrollmentId);
  }

  @Get('class-subject')
  @ApiOperation({ summary: 'Listar notas por turma, disciplina e trimestre' })
  @ApiQuery({ name: 'schoolClassId', required: true })
  @ApiQuery({ name: 'subjectId', required: true })
  @ApiQuery({ name: 'trimester', required: true, type: Number })
  findByClassAndSubject(
    @Query('schoolClassId') schoolClassId: string,
    @Query('subjectId') subjectId: string,
    @Query('trimester') trimester: string,
  ) {
    return this.service.findByClassAndSubject(schoolClassId, subjectId, Number(trimester));
  }

  @Patch(':id')
  @Roles('ADMIN', 'PROFESSOR')
  @ApiOperation({ summary: 'Actualizar valor de uma nota' })
  update(@Param('id') id: string, @Body('value') value: number) {
    return this.service.update(id, value);
  }

  @Delete(':id')
  @Roles('ADMIN')
  @ApiOperation({ summary: 'Remover uma nota' })
  remove(@Param('id') id: string) {
    return this.service.remove(id);
  }
}
