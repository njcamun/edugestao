import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateInvoiceDto } from './dto/create-invoice.dto';
import { CreatePaymentDto } from './dto/create-payment.dto';
import { InvoiceStatus } from '@prisma/client';

@Injectable()
export class FinanceService {
  constructor(private readonly prisma: PrismaService) {}

  async createInvoice(dto: CreateInvoiceDto) {
    return this.prisma.invoice.create({
      data: dto,
    });
  }

  async findAllInvoices(enrollmentId?: string) {
    return this.prisma.invoice.findMany({
      where: enrollmentId ? { enrollmentId } : {},
      include: {
        enrollment: {
          include: { student: true },
        },
        payments: true,
      },
      orderBy: { dueDate: 'asc' },
    });
  }

  async findInvoice(id: string) {
    const invoice = await this.prisma.invoice.findUnique({
      where: { id },
      include: {
        enrollment: {
          include: { student: true },
        },
        payments: true,
      },
    });
    if (!invoice) throw new NotFoundException('Cobrança não encontrada');
    return invoice;
  }

  async createPayment(dto: CreatePaymentDto) {
    const invoice = await this.findInvoice(dto.invoiceId);

    const payment = await this.prisma.payment.create({
      data: {
        invoiceId: dto.invoiceId,
        amountPaid: dto.amountPaid,
        paymentMethod: dto.paymentMethod,
        paymentDate: dto.paymentDate ? new Date(dto.paymentDate) : new Date(),
      },
    });

    // Calcular novo estado da fatura
    const totalPaid = invoice.payments.reduce((sum, p) => sum + p.amountPaid, 0) + dto.amountPaid;
    let newStatus: InvoiceStatus = InvoiceStatus.PARCIAL;

    if (totalPaid >= invoice.amount) {
      newStatus = InvoiceStatus.PAGO;
    } else if (totalPaid === 0 && new Date(invoice.dueDate) < new Date()) {
      newStatus = InvoiceStatus.VENCIDO;
    }

    await this.prisma.invoice.update({
      where: { id: dto.invoiceId },
      data: { status: newStatus },
    });

    return payment;
  }

  async getDashboardStats() {
    const now = new Date();
    const firstDayOfMonth = new Date(now.getFullYear(), now.getMonth(), 1);

    const [receivedThisMonth, totalDebt, debtorsCount] = await Promise.all([
      this.prisma.payment.aggregate({
        where: { paymentDate: { gte: firstDayOfMonth } },
        _sum: { amountPaid: true },
      }),
      this.prisma.invoice.aggregate({
        where: { status: { in: [InvoiceStatus.PENDENTE, InvoiceStatus.PARCIAL, InvoiceStatus.VENCIDO] } },
        _sum: { amount: true },
      }),
      this.prisma.invoice.count({
        where: { status: InvoiceStatus.VENCIDO },
      }),
    ]);

    return {
      receivedMonth: receivedThisMonth._sum.amountPaid || 0,
      totalDebt: totalDebt._sum.amount || 0,
      debtorsCount,
    };
  }
}
