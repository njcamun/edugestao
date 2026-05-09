import { INestApplication } from "@nestjs/common";
import { Test } from "@nestjs/testing";
import * as request from "supertest";
import { RolesGuard } from "../../common/roles.guard";
import { JwtAuthGuard } from "../auth/jwt-auth.guard";
import { FinanceController } from "./finance.controller";
import { FinanceService } from "./finance.service";

describe("FinanceController (integration)", () => {
  let app: INestApplication;

  const financeServiceMock = {
    getDashboardStats: jest.fn(),
    createPayment: jest.fn(),
  };

  beforeAll(async () => {
    const moduleRef = await Test.createTestingModule({
      controllers: [FinanceController],
      providers: [{ provide: FinanceService, useValue: financeServiceMock }],
    })
      .overrideGuard(JwtAuthGuard)
      .useValue({ canActivate: () => true })
      .overrideGuard(RolesGuard)
      .useValue({ canActivate: () => true })
      .compile();

    app = moduleRef.createNestApplication();
    await app.init();
  });

  afterAll(async () => {
    await app.close();
  });

  beforeEach(() => {
    jest.clearAllMocks();
  });

  it("GET /finance/dashboard deve devolver estatísticas financeiras", async () => {
    financeServiceMock.getDashboardStats.mockResolvedValue({
      receivedMonth: 120000,
      totalDebt: 30000,
      debtorsCount: 8,
    });

    const response = await request(app.getHttpServer()).get("/finance/dashboard");

    expect(response.status).toBe(200);
    expect(response.body).toEqual({
      receivedMonth: 120000,
      totalDebt: 30000,
      debtorsCount: 8,
    });
    expect(financeServiceMock.getDashboardStats).toHaveBeenCalledTimes(1);
  });

  it("POST /finance/payments deve encaminhar payload para o service", async () => {
    const payload = {
      invoiceId: "inv-100",
      amountPaid: 5000,
      paymentMethod: "DINHEIRO",
      paymentDate: "2026-05-09",
    };
    financeServiceMock.createPayment.mockResolvedValue({ id: "pay-100", ...payload });

    const response = await request(app.getHttpServer())
      .post("/finance/payments")
      .send(payload);

    expect(response.status).toBe(201);
    expect(financeServiceMock.createPayment).toHaveBeenCalledWith(payload);
    expect(response.body.id).toBe("pay-100");
  });
});
