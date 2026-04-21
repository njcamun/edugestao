import { Controller, Get, Post, Body, Param, Delete, UseGuards } from '@nestjs/common';
import { ApiTags, ApiBearerAuth, ApiOperation } from '@nestjs/swagger';
import { SchedulesService } from './schedules.service';
import { CreateScheduleItemDto } from './dto/create-schedule-item.dto';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { RolesGuard } from '../../common/roles.guard';
import { Roles } from '../../common/roles.decorator';

@ApiTags('schedules')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Controller('schedules')
export class SchedulesController {
  constructor(private readonly service: SchedulesService) {}

  @Post()
  @Roles('ADMIN', 'SECRETARIA')
  @ApiOperation({ summary: 'Criar um item de horário (com validação de conflitos)' })
  create(@Body() dto: CreateScheduleItemDto) {
    return this.service.create(dto);
  }

  @Get('class/:schoolClassId')
  @ApiOperation({ summary: 'Obter horário de uma turma' })
  findByClass(@Param('schoolClassId') schoolClassId: string) {
    return this.service.findByClass(schoolClassId);
  }

  @Get('teacher/:teacherId')
  @ApiOperation({ summary: 'Obter horário de um professor' })
  findByTeacher(@Param('teacherId') teacherId: string) {
    return this.service.findByTeacher(teacherId);
  }

  @Get('room/:roomId')
  @ApiOperation({ summary: 'Obter ocupação de uma sala' })
  findByRoom(@Param('roomId') roomId: string) {
    return this.service.findByRoom(roomId);
  }

  @Delete(':id')
  @Roles('ADMIN', 'SECRETARIA')
  @ApiOperation({ summary: 'Remover item do horário' })
  remove(@Param('id') id: string) {
    return this.service.remove(id);
  }
}
