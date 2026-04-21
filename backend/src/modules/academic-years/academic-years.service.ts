import { Injectable, ConflictException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateAcademicYearDto } from './dto/create-academic-year.dto';

@Injectable()
export class AcademicYearsService {
  constructor(private readonly prisma: PrismaService) {}

  async findAll() {
    return this.prisma.academicYear.findMany({
      orderBy: { year: 'desc' },
    });
  }

  async create(dto: CreateAcademicYearDto) {
    const existing = await this.prisma.academicYear.findUnique({
      where: { year: dto.year },
    });
    if (existing) {
      throw new ConflictException('Ano lectivo já existe');
    }
    return this.prisma.academicYear.create({
      data: {
        year: dto.year,
        startDate: new Date(dto.startDate),
        endDate: new Date(dto.endDate),
        isActive: dto.isActive ?? true,
      },
    });
  }

  async findActive() {
    return this.prisma.academicYear.findFirst({
      where: { isActive: true },
      orderBy: { year: 'desc' },
    });
  }
}
