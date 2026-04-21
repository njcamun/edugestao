import { Controller, Get, Param, Query, Res, UseGuards } from "@nestjs/common";
import { ApiBearerAuth, ApiTags } from "@nestjs/swagger";
import { AuthGuard } from "@nestjs/passport";
import { Roles } from "../../common/roles.decorator";
import { RolesGuard } from "../../common/roles.guard";
import { ReportsService } from "./reports.service";
import type { Response } from "express";

@ApiTags("reports")
@ApiBearerAuth()
@UseGuards(AuthGuard("jwt"), RolesGuard)
@Controller("reports")
export class ReportsController {
  constructor(private readonly reports: ReportsService) {}

  @Get("report-card/:studentId")
  @Roles("ADMIN", "SECRETARIA", "PROFESSOR")
  async reportCard(
    @Param("studentId") studentId: string,
    @Query("term") term: string,
    @Res() res: Response,
  ) {
    const t = (Number(term) || 1) as 1 | 2 | 3;
    const doc = await this.reports.generateReportCard(studentId, t);

    res.setHeader("Content-Type", "application/pdf");
    res.setHeader("Content-Disposition", `inline; filename="boletim_${studentId}_T${t}.pdf"`);

    doc.pipe(res);
    doc.end();
  }
}
