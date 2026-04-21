import { Injectable, NotFoundException } from "@nestjs/common";
import PDFDocument from "pdfkit";
import { PrismaService } from "../prisma/prisma.service";

@Injectable()
export class ReportsService {
  constructor(private readonly prisma: PrismaService) {}

  async generateReportCard(enrollmentId: string, trimester?: number) {
    const enrollment = await this.prisma.enrollment.findUnique({
      where: { id: enrollmentId },
      include: {
        student: true,
        schoolClass: {
          include: {
            gradeLevel: true,
            academicYear: true,
          }
        },
        grades: {
          include: { subject: true }
        }
      }
    });

    if (!enrollment) throw new NotFoundException("Matrícula não encontrada");

    const doc = new PDFDocument({ size: "A4", margin: 50 });

    // Design do Cabeçalho
    doc.fontSize(18).text("SISTEMA DE GESTÃO ESCOLAR - EDUGESTAO", { align: "center", bold: true } as any);
    doc.fontSize(14).text("BOLETIM DE NOTAS", { align: "center" });
    doc.moveDown();

    // Dados do Aluno e Turma
    doc.fontSize(10);
    const startY = doc.y;
    doc.text(`Aluno: ${enrollment.student.fullName}`, 50, startY);
    doc.text(`Ano Lectivo: ${enrollment.schoolClass.academicYear.year}`, 350, startY);
    doc.text(`Turma: ${enrollment.schoolClass.name}`, 50, startY + 15);
    doc.text(`Classe: ${enrollment.schoolClass.gradeLevel.name}`, 350, startY + 15);
    doc.moveDown(2);

    // Tabela de Notas
    const tableTop = 150;
    doc.font("Helvetica-Bold").fontSize(10);
    doc.text("Disciplina", 50, tableTop);
    doc.text("Tri 1", 200, tableTop);
    doc.text("Tri 2", 250, tableTop);
    doc.text("Tri 3", 300, tableTop);
    doc.text("Média", 350, tableTop);
    doc.text("OBS", 400, tableTop);

    doc.moveTo(50, tableTop + 15).lineTo(550, tableTop + 15).stroke();

    doc.font("Helvetica").fontSize(10);
    let currentY = tableTop + 25;

    // Agrupar notas por disciplina
    const subjectsMap = new Map();
    // Buscar todas as disciplinas da turma via teacher assignments para garantir que aparecem todas
    const assignments = await this.prisma.teacherAssignment.findMany({
        where: { schoolClassId: enrollment.schoolClassId },
        include: { subject: true }
    });

    assignments.forEach(a => {
        subjectsMap.set(a.subjectId, { name: a.subject.name, t1: "-", t2: "-", t3: "-", avg: 0 });
    });

    enrollment.grades.forEach(g => {
        const sub = subjectsMap.get(g.subjectId);
        if (sub) {
            if (g.trimester === 1) sub.t1 = g.value;
            if (g.trimester === 2) sub.t2 = g.value;
            if (g.trimester === 3) sub.t3 = g.value;
        }
    });

    subjectsMap.forEach((data, id) => {
        doc.text(data.name, 50, currentY);
        doc.text(data.t1.toString(), 200, currentY);
        doc.text(data.t2.toString(), 250, currentY);
        doc.text(data.t3.toString(), 300, currentY);

        // Cálculo simples de média (pode ser ajustado por pesos)
        const grades = [data.t1, data.t2, data.t3].filter(v => typeof v === 'number');
        const avg = grades.length > 0 ? (grades.reduce((a, b) => a + b, 0) / grades.length).toFixed(1) : "-";

        doc.text(avg.toString(), 350, currentY);
        doc.text(Number(avg) >= 10 ? "Aprovado" : (avg === "-" ? "" : "Reprovado"), 400, currentY);

        currentY += 20;
    });

    // Rodapé
    const footerY = 700;
    doc.moveTo(50, footerY).lineTo(200, footerY).stroke();
    doc.moveTo(350, footerY).lineTo(500, footerY).stroke();

    doc.fontSize(9);
    doc.text("O Director Geral", 50, footerY + 5, { width: 150, align: "center" });
    doc.text("O Encarregado de Educação", 350, footerY + 5, { width: 150, align: "center" });

    doc.text(`Emitido em: ${new Date().toLocaleDateString("pt-PT")}`, 50, 750);

    return doc;
  }
}
