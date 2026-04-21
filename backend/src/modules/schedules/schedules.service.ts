import { Injectable, ConflictException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateScheduleItemDto } from './dto/create-schedule-item.dto';

@Injectable()
export class SchedulesService {
  constructor(private readonly prisma: PrismaService) {}

  async create(dto: CreateScheduleItemDto) {
    // 1. Validar conflito de Professor
    const teacherConflict = await this.prisma.scheduleItem.findFirst({
      where: {
        teacherId: dto.teacherId,
        dayOfWeek: dto.dayOfWeek,
        OR: [
          {
            startTime: { lte: dto.startTime },
            endTime: { gt: dto.startTime },
          },
          {
            startTime: { lt: dto.endTime },
            endTime: { gte: dto.endTime },
          },
        ],
      },
    });

    if (teacherConflict) {
      throw new ConflictException('O professor já tem uma aula neste horário.');
    }

    // 2. Validar conflito de Sala
    const roomConflict = await this.prisma.scheduleItem.findFirst({
      where: {
        roomId: dto.roomId,
        dayOfWeek: dto.dayOfWeek,
        OR: [
          {
            startTime: { lte: dto.startTime },
            endTime: { gt: dto.startTime },
          },
          {
            startTime: { lt: dto.endTime },
            endTime: { gte: dto.endTime },
          },
        ],
      },
    });

    if (roomConflict) {
      throw new ConflictException('A sala já está ocupada neste horário.');
    }

    return this.prisma.scheduleItem.create({
      data: dto,
    });
  }

  async findByClass(schoolClassId: string) {
    return this.prisma.scheduleItem.findMany({
      where: { schoolClassId },
      include: {
        teacher: { include: { user: true } },
        room: true,
      },
      orderBy: [{ dayOfWeek: 'asc' }, { startTime: 'asc' }],
    });
  }

  async findByTeacher(teacherId: string) {
    return this.prisma.scheduleItem.findMany({
      where: { teacherId },
      include: {
        schoolClass: { include: { gradeLevel: true } },
        room: true,
      },
      orderBy: [{ dayOfWeek: 'asc' }, { startTime: 'asc' }],
    });
  }

  async findByRoom(roomId: string) {
    return this.prisma.scheduleItem.findMany({
      where: { roomId },
      include: {
        schoolClass: { include: { gradeLevel: true } },
        teacher: { include: { user: true } },
      },
      orderBy: [{ dayOfWeek: 'asc' }, { startTime: 'asc' }],
    });
  }

  async remove(id: string) {
    return this.prisma.scheduleItem.delete({ where: { id } });
  }
}
