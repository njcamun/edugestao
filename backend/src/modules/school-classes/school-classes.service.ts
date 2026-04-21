import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateSchoolClassDto } from './dto/create-school-class.dto';

@Injectable()
export class SchoolClassesService {
  constructor(private readonly prisma: PrismaService) {}

  async create(dto: CreateSchoolClassDto) {
    return this.prisma.schoolClass.create({
      data: dto,
    });
  }

  async findAll(academicYearId?: string) {
    return this.prisma.schoolClass.findMany({
      where: academicYearId ? { academicYearId } : {},
      include: {
        academicYear: true,
        gradeLevel: true,
        room: true,
        _count: {
          select: { enrollments: true },
        },
      },
    });
  }

  async findOne(id: string) {
    const schoolClass = await this.prisma.schoolClass.findUnique({
      where: { id },
      include: {
        academicYear: true,
        gradeLevel: true,
        room: true,
        enrollments: {
          include: { student: true },
        },
        teacherAssignments: {
          include: {
            teacher: { include: { user: true } },
            subject: true,
          },
        },
      },
    });
    if (!schoolClass) throw new NotFoundException('Turma não encontrada');
    return schoolClass;
  }
}
