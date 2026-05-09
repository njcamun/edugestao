import { StudentsService } from "./students.service";

describe("StudentsService", () => {
  const prisma = {
    student: {
      findMany: jest.fn(),
      count: jest.fn(),
      findUnique: jest.fn(),
      create: jest.fn(),
      update: jest.fn(),
      delete: jest.fn(),
    },
  } as any;

  let service: StudentsService;

  beforeEach(() => {
    jest.clearAllMocks();
    service = new StudentsService(prisma);
  });

  it("deve listar estudantes paginados sem filtro", async () => {
    const rows = [{ id: "s1", fullName: "Ana Silva" }];
    prisma.student.findMany.mockResolvedValue(rows);
    prisma.student.count.mockResolvedValue(1);

    const result = await service.list(undefined, 2, 10);

    expect(prisma.student.findMany).toHaveBeenCalledWith({
      where: undefined,
      orderBy: { createdAt: "desc" },
      skip: 10,
      take: 10,
    });
    expect(prisma.student.count).toHaveBeenCalledWith({ where: undefined });
    expect(result).toEqual({ items: rows, total: 1, page: 2, pageSize: 10 });
  });

  it("deve aplicar filtro por nome na listagem", async () => {
    prisma.student.findMany.mockResolvedValue([]);
    prisma.student.count.mockResolvedValue(0);

    await service.list("maria", 1, 20);

    const expectedWhere = { fullName: { contains: "maria", mode: "insensitive" } };
    expect(prisma.student.findMany).toHaveBeenCalledWith({
      where: expectedWhere,
      orderBy: { createdAt: "desc" },
      skip: 0,
      take: 20,
    });
    expect(prisma.student.count).toHaveBeenCalledWith({ where: expectedWhere });
  });

  it("deve delegar create/update/delete para prisma", async () => {
    prisma.student.create.mockResolvedValue({ id: "s1" });
    prisma.student.update.mockResolvedValue({ id: "s1" });
    prisma.student.delete.mockResolvedValue({ id: "s1" });

    await service.create({ fullName: "Aluno Teste" });
    await service.update("s1", { phone: "999000111" });
    await service.remove("s1");

    expect(prisma.student.create).toHaveBeenCalledWith({ data: { fullName: "Aluno Teste" } });
    expect(prisma.student.update).toHaveBeenCalledWith({ where: { id: "s1" }, data: { phone: "999000111" } });
    expect(prisma.student.delete).toHaveBeenCalledWith({ where: { id: "s1" } });
  });
});
