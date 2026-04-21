import { Injectable, ConflictException, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateEnrollmentDto } from './dto/create-enrollment.dto';

@Injectable()
export class EnrollmentsService {
  constructor(private readonly prisma: PrismaService) {}

  async create(dto: CreateEnrollmentDto) {
    // Verificar se o aluno existe
    const student = await this.prisma.student.findUnique({ where: { id: dto.studentId } });
    if (!student) throw new NotFoundException('Aluno não encontrado');

    // Verificar se a turma existe
    const schoolClass = await this.prisma.schoolClass.findUnique({ where: { id: dto.schoolClassId } });
    if (!schoolClass) throw new NotFoundException('Turma não encontrada');

    // Regra: um aluno não pode ter duas matrículas no mesmo ano lectivo
    // A constraint unique no Prisma já trata isso, mas vamos validar explicitamente para retornar erro amigável
    const existing = await this.prisma.enrollment.findUnique({
      where: {
        studentId_academicYearId: {
          studentId: dto.studentId,
          academicYearId: dto.academicYearId,
        },
      },
    });

    if (existing) {
      throw new ConflictException('O aluno já possui uma matrícula para este ano lectivo');
    }

    return this.prisma.enrollment.create({
      data: {
        studentId: dto.studentId,
        schoolClassId: dto.schoolClassId,
        academicYearId: dto.academicYearId,
        status: dto.status,
      },
    });
  }

  async findAll(academicYearId?: string) {
    return this.prisma.enrollment.findMany({
      where: academicYearId ? { academicYearId } : {},
      include: {
        student: true,
        schoolClass: {
          include: { gradeLevel: true }
        },
        academicYear: true,
      },
    });
  }

  async findOne(id: string) {
    const enrollment = await this.prisma.enrollment.findUnique({
      where: { id },
      include: {
        student: true,
        schoolClass: true,
        academicYear: true,
        grades: true,
        invoices: true,
      },
    });
    if (!enrollment) throw new NotFoundException('Matrícula não encontrada');
    return enrollment;
  }
}
