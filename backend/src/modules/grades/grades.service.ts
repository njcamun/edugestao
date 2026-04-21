import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateGradeDto } from './dto/create-grade.dto';

@Injectable()
export class GradesService {
  constructor(private readonly prisma: PrismaService) {}

  async create(dto: CreateGradeDto) {
    return this.prisma.grade.create({
      data: dto,
    });
  }

  async findByEnrollment(enrollmentId: string) {
    return this.prisma.grade.findMany({
      where: { enrollmentId },
      include: { subject: true },
      orderBy: [{ trimester: 'asc' }, { subject: { name: 'asc' } }],
    });
  }

  async findByClassAndSubject(schoolClassId: string, subjectId: string, trimester: number) {
    return this.prisma.grade.findMany({
      where: {
        subjectId,
        trimester,
        enrollment: {
          schoolClassId,
        },
      },
      include: {
        enrollment: {
          include: { student: true },
        },
      },
    });
  }

  async update(id: string, value: number) {
    return this.prisma.grade.update({
      where: { id },
      data: { value },
    });
  }

  async remove(id: string) {
    return this.prisma.grade.delete({ where: { id } });
  }
}
