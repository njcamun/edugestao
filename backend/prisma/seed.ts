import { PrismaClient, UserRole, EnrollmentStatus, PaymentMethod } from "@prisma/client";
import * as bcrypt from "bcryptjs";

const prisma = new PrismaClient();

async function main() {
  const passwordHash = await bcrypt.hash("Admin@123", 10);

  // 1. Users
  const admin = await prisma.user.upsert({
    where: { email: "admin@escola.local" },
    update: {},
    create: { email: "admin@escola.local", name: "Admin Geral", passwordHash, role: UserRole.ADMIN }
  });

  const sec = await prisma.user.upsert({
    where: { email: "sec@escola.local" },
    update: {},
    create: { email: "sec@escola.local", name: "Secretaria 01", passwordHash, role: UserRole.SECRETARIA }
  });

  const profUser = await prisma.user.upsert({
    where: { email: "prof@escola.local" },
    update: {},
    create: { email: "prof@escola.local", name: "Professor Silva", passwordHash, role: UserRole.PROFESSOR }
  });

  const fin = await prisma.user.upsert({
    where: { email: "fin@escola.local" },
    update: {},
    create: { email: "fin@escola.local", name: "Financeiro 01", passwordHash, role: UserRole.FINANCEIRO }
  });

  // 2. Teacher profile
  const teacher = await prisma.teacher.upsert({
    where: { userId: profUser.id },
    update: {},
    create: { userId: profUser.id }
  });

  // 3. Academic Year
  const year2025 = await prisma.academicYear.upsert({
    where: { year: "2025" },
    update: {},
    create: {
      year: "2025",
      startDate: new Date("2025-02-01"),
      endDate: new Date("2025-12-15"),
      isActive: true
    }
  });

  // 4. Grade Levels & Rooms & Subjects
  const decima = await prisma.gradeLevel.create({ data: { name: "10ª Classe" } });
  const sala1 = await prisma.room.create({ data: { name: "Sala 01", capacity: 30 } });
  const matematica = await prisma.subject.create({ data: { name: "Matemática" } });
  const portugues = await prisma.subject.create({ data: { name: "Português" } });

  // 5. School Class
  const turmaA = await prisma.schoolClass.create({
    data: {
      name: "Turma A",
      academicYearId: year2025.id,
      gradeLevelId: decima.id,
      roomId: sala1.id
    }
  });

  // 6. Teacher Assignment
  await prisma.teacherAssignment.create({
    data: {
      teacherId: teacher.id,
      subjectId: matematica.id,
      schoolClassId: turmaA.id
    }
  });

  // 7. Students & Enrollment
  const student1 = await prisma.student.create({
    data: { fullName: "João Manuel", phone: "923000111", gender: "M" }
  });

  const enrollment = await prisma.enrollment.create({
    data: {
      studentId: student1.id,
      schoolClassId: turmaA.id,
      academicYearId: year2025.id,
      status: EnrollmentStatus.CONFIRMADA
    }
  });

  // 8. Finance (Invoice for Enrollment)
  await prisma.invoice.create({
    data: {
      enrollmentId: enrollment.id,
      description: "Taxa de Matrícula 2025",
      amount: 15000,
      dueDate: new Date("2025-01-31"),
      status: "PENDENTE"
    }
  });

  console.log("Seed completed successfully.");
}

main()
  .then(() => prisma.$disconnect())
  .catch((e) => {
    console.error(e);
    return prisma.$disconnect().finally(() => process.exit(1));
  });
