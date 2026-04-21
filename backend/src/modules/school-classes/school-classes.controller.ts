import { Controller, Get, Post, Body, Param, Query, UseGuards } from '@nestjs/common';
import { ApiTags, ApiBearerAuth, ApiOperation, ApiQuery } from '@nestjs/swagger';
import { SchoolClassesService } from './school-classes.service';
import { CreateSchoolClassDto } from './dto/create-school-class.dto';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { RolesGuard } from '../../common/roles.guard';
import { Roles } from '../../common/roles.decorator';

@ApiTags('school-classes')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Controller('school-classes')
export class SchoolClassesController {
  constructor(private readonly service: SchoolClassesService) {}

  @Post()
  @Roles('ADMIN', 'SECRETARIA')
  @ApiOperation({ summary: 'Criar uma nova turma' })
  create(@Body() dto: CreateSchoolClassDto) {
    return this.service.create(dto);
  }

  @Get()
  @ApiOperation({ summary: 'Listar todas as turmas' })
  @ApiQuery({ name: 'academicYearId', required: false })
  findAll(@Query('academicYearId') academicYearId?: string) {
    return this.service.findAll(academicYearId);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Obter detalhes de uma turma' })
  findOne(@Param('id') id: string) {
    return this.service.findOne(id);
  }
}
