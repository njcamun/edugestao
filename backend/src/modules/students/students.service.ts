import { Injectable } from "@nestjs/common";
import { PrismaService } from "../prisma/prisma.service";
import { CreateStudentDto } from "./dto/create-student.dto";
import { UpdateStudentDto } from "./dto/update-student.dto";

@Injectable()
export class StudentsService {
  constructor(private readonly prisma: PrismaService) {}

  async list(q?: string, page = 1, pageSize = 20) {
    const where = q
      ? { fullName: { contains: q, mode: "insensitive" as const } }
      : undefined;

    const [items, total] = await Promise.all([
      this.prisma.student.findMany({
        where,
        orderBy: { createdAt: "desc" },
        skip: (page - 1) * pageSize,
        take: pageSize,
      }),
      this.prisma.student.count({ where }),
    ]);

    return { items, total, page, pageSize };
  }

  get(id: string) {
    return this.prisma.student.findUnique({ where: { id } });
  }

  create(dto: CreateStudentDto) {
    return this.prisma.student.create({ data: dto });
  }

  update(id: string, dto: UpdateStudentDto) {
    return this.prisma.student.update({ where: { id }, data: dto });
  }

  remove(id: string) {
    return this.prisma.student.delete({ where: { id } });
  }
}
