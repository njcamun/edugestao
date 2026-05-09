jest.mock("pdfkit", () => {
  const docMock = {
    y: 120,
    fontSize: jest.fn().mockReturnThis(),
    text: jest.fn().mockReturnThis(),
    moveDown: jest.fn().mockReturnThis(),
    font: jest.fn().mockReturnThis(),
    moveTo: jest.fn().mockReturnThis(),
    lineTo: jest.fn().mockReturnThis(),
    stroke: jest.fn().mockReturnThis(),
    pipe: jest.fn().mockReturnThis(),
    end: jest.fn(),
  };

  return {
    __esModule: true,
    default: jest.fn().mockImplementation(() => docMock),
  };
});

import { NotFoundException } from "@nestjs/common";
import PDFDocument from "pdfkit";
import { ReportsService } from "./reports.service";

describe("ReportsService", () => {
  const prisma = {
    enrollment: {
      findUnique: jest.fn(),
    },
    teacherAssignment: {
      findMany: jest.fn(),
    },
  } as any;

  let service: ReportsService;

  beforeEach(() => {
    jest.clearAllMocks();
    service = new ReportsService(prisma);
  });

  it("deve lançar erro quando matrícula não existe", async () => {
    prisma.enrollment.findUnique.mockResolvedValue(null);

    await expect(service.generateReportCard("invalid-id")).rejects.toBeInstanceOf(NotFoundException);
  });

  it("deve gerar documento PDF quando matrícula existe", async () => {
    prisma.enrollment.findUnique.mockResolvedValue({
      id: "enr-1",
      schoolClassId: "class-1",
      student: { fullName: "Aluno Exemplo" },
      schoolClass: {
        name: "Turma A",
        gradeLevel: { name: "10a Classe" },
        academicYear: { year: "2025/2026" },
      },
      grades: [
        { subjectId: "sub-1", trimester: 1, value: 14, subject: { name: "Matematica" } },
      ],
    });
    prisma.teacherAssignment.findMany.mockResolvedValue([
      { subjectId: "sub-1", subject: { name: "Matematica" } },
    ]);

    const doc = await service.generateReportCard("enr-1");

    expect(prisma.teacherAssignment.findMany).toHaveBeenCalledWith({
      where: { schoolClassId: "class-1" },
      include: { subject: true },
    });
    expect(doc).toBeDefined();
    expect(doc).toBeInstanceOf(Object);
    expect((PDFDocument as unknown as jest.Mock)).toHaveBeenCalledTimes(1);
  });
});
