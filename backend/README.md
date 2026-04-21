# Backend — NestJS + Prisma + Postgres

## Executar local (sem Docker)
1) Copia `.env.example` para `.env` e ajusta `DATABASE_URL`.
2) Instala deps:
```bash
npm install
```
3) Gera prisma:
```bash
npm run prisma:generate
```
4) Cria migrations (primeira vez):
```bash
npx prisma migrate dev --name init
```
5) Seed:
```bash
npm run seed
```
6) Start:
```bash
npm run start:dev
```

## Endpoints rápidos
- `POST /auth/login`
- `GET /students` (auth)
- `GET /reports/report-card/:studentId?term=1` (auth)
