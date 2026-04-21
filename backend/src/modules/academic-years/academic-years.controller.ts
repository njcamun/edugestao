import { Controller, Get, Post, Body, UseGuards } from '@nestjs/common';
import { ApiTags, ApiBearerAuth, ApiOperation } from '@nestjs/swagger';
import { AcademicYearsService } from './academic-years.service';
import { CreateAcademicYearDto } from './dto/create-academic-year.dto';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { RolesGuard } from '../../common/roles.guard';
import { Roles } from '../../common/roles.decorator';

@ApiTags('academic-years')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Controller('academic-years')
export class AcademicYearsController {
  constructor(private readonly service: AcademicYearsService) {}

  @Get()
  @ApiOperation({ summary: 'Listar todos os anos lectivos' })
  findAll() {
    return this.service.findAll();
  }

  @Post()
  @Roles('ADMIN')
  @ApiOperation({ summary: 'Criar um novo ano lectivo (Apenas Admin)' })
  create(@Body() dto: CreateAcademicYearDto) {
    return this.service.create(dto);
  }

  @Get('active')
  @ApiOperation({ summary: 'Obter o ano lectivo activo' })
  findActive() {
    return this.service.findActive();
  }
}
