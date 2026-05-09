import { UnauthorizedException } from "@nestjs/common";
import { JwtService } from "@nestjs/jwt";
import { ConfigService } from "@nestjs/config";
import * as bcrypt from "bcryptjs";
import { AuthService } from "./auth.service";

describe("AuthService", () => {
  const prisma = {
    user: {
      findUnique: jest.fn(),
    },
  } as any;

  const jwt = {
    signAsync: jest.fn(),
  } as unknown as JwtService;

  const config = {
    get: jest.fn((key: string) => (key === "JWT_REFRESH_SECRET" ? "refresh-secret-test" : undefined)),
  } as unknown as ConfigService;

  let service: AuthService;

  beforeEach(() => {
    jest.clearAllMocks();
    service = new AuthService(prisma, jwt, config);
  });

  it("deve autenticar utilizador ativo com credenciais validas", async () => {
    prisma.user.findUnique.mockResolvedValue({
      id: "u1",
      email: "admin@school.com",
      name: "Admin",
      role: "ADMIN",
      passwordHash: "hash",
      isActive: true,
    });
    jest.spyOn(bcrypt, "compare").mockResolvedValue(true as never);
    (jwt.signAsync as jest.Mock)
      .mockResolvedValueOnce("access-token")
      .mockResolvedValueOnce("refresh-token");

    const result = await service.login("admin@school.com", "password123");

    expect(result).toEqual({
      accessToken: "access-token",
      refreshToken: "refresh-token",
      user: {
        id: "u1",
        email: "admin@school.com",
        name: "Admin",
        role: "ADMIN",
      },
    });
    expect(prisma.user.findUnique).toHaveBeenCalledWith({ where: { email: "admin@school.com" } });
    expect(jwt.signAsync).toHaveBeenNthCalledWith(1, {
      sub: "u1",
      role: "ADMIN",
      email: "admin@school.com",
      name: "Admin",
    });
    expect(jwt.signAsync).toHaveBeenNthCalledWith(
      2,
      {
        sub: "u1",
        role: "ADMIN",
        email: "admin@school.com",
        name: "Admin",
      },
      { secret: "refresh-secret-test", expiresIn: "30d" },
    );
  });

  it("deve falhar quando utilizador nao existe", async () => {
    prisma.user.findUnique.mockResolvedValue(null);

    await expect(service.login("inexistente@school.com", "123456")).rejects.toBeInstanceOf(UnauthorizedException);
  });

  it("deve falhar quando password e invalida", async () => {
    prisma.user.findUnique.mockResolvedValue({
      id: "u2",
      email: "user@school.com",
      name: "User",
      role: "USER",
      passwordHash: "hash",
      isActive: true,
    });
    jest.spyOn(bcrypt, "compare").mockResolvedValue(false as never);

    await expect(service.login("user@school.com", "wrong-pass")).rejects.toBeInstanceOf(UnauthorizedException);
  });
});
