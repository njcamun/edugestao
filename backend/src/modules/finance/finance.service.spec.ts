import { NotFoundException } from "@nestjs/common";
import { InvoiceStatus, PaymentMethod } from "@prisma/client";
import { FinanceService } from "./finance.service";

describe("FinanceService", () => {
  const prisma = {
    invoice: {
      create: jest.fn(),
      findMany: jest.fn(),
      findUnique: jest.fn(),
      update: jest.fn(),
      aggregate: jest.fn(),
      count: jest.fn(),
    },
    payment: {
      create: jest.fn(),
      aggregate: jest.fn(),
    },
  } as any;

  let service: FinanceService;

  beforeEach(() => {
    jest.clearAllMocks();
    service = new FinanceService(prisma);
  });

  it("deve marcar fatura como PAGO quando total pago atingir valor", async () => {
    prisma.invoice.findUnique.mockResolvedValue({
      id: "inv-1",
      amount: 1000,
      dueDate: new Date("2030-01-10"),
      payments: [{ amountPaid: 300 }],
      enrollment: { student: { fullName: "Aluno A" } },
    });
    prisma.payment.create.mockResolvedValue({ id: "pay-1", amountPaid: 700 });
    prisma.invoice.update.mockResolvedValue({ id: "inv-1", status: InvoiceStatus.PAGO });

    const result = await service.createPayment({
      invoiceId: "inv-1",
      amountPaid: 700,
      paymentMethod: PaymentMethod.DINHEIRO,
    });

    expect(prisma.payment.create).toHaveBeenCalled();
    expect(prisma.invoice.update).toHaveBeenCalledWith({
      where: { id: "inv-1" },
      data: { status: InvoiceStatus.PAGO },
    });
    expect(result).toEqual({ id: "pay-1", amountPaid: 700 });
  });

  it("deve manter fatura como PARCIAL quando valor pago for insuficiente", async () => {
    prisma.invoice.findUnique.mockResolvedValue({
      id: "inv-2",
      amount: 1000,
      dueDate: new Date("2030-01-10"),
      payments: [{ amountPaid: 100 }],
      enrollment: { student: { fullName: "Aluno B" } },
    });
    prisma.payment.create.mockResolvedValue({ id: "pay-2", amountPaid: 200 });

    await service.createPayment({
      invoiceId: "inv-2",
      amountPaid: 200,
      paymentMethod: PaymentMethod.TRANSFERENCIA,
    });

    expect(prisma.invoice.update).toHaveBeenCalledWith({
      where: { id: "inv-2" },
      data: { status: InvoiceStatus.PARCIAL },
    });
  });

  it("deve lançar erro ao buscar cobrança inexistente", async () => {
    prisma.invoice.findUnique.mockResolvedValue(null);

    await expect(service.findInvoice("missing-id")).rejects.toBeInstanceOf(NotFoundException);
  });
});
