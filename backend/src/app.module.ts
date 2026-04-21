import { Module } from "@nestjs/common";
import { ConfigModule } from "@nestjs/config";
import { AppController } from "./app.controller";
import { AuthModule } from "./modules/auth/auth.module";
import { PrismaModule } from "./modules/prisma/prisma.module";
import { StudentsModule } from "./modules/students/students.module";
import { ReportsModule } from "./modules/reports/reports.module";
import { AcademicYearsModule } from "./modules/academic-years/academic-years.module";
import { EnrollmentsModule } from "./modules/enrollments/enrollments.module";
import { SchoolClassesModule } from "./modules/school-classes/school-classes.module";
import { GradesModule } from "./modules/grades/grades.module";
import { FinanceModule } from "./modules/finance/finance.module";
import { SchedulesModule } from "./modules/schedules/schedules.module";

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true }),
    PrismaModule,
    AuthModule,
    StudentsModule,
    ReportsModule,
    AcademicYearsModule,
    EnrollmentsModule,
    SchoolClassesModule,
    GradesModule,
    FinanceModule,
    SchedulesModule,
  ],
  controllers: [AppController],
})
export class AppModule {}
