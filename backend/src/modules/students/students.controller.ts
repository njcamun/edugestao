import { Body, Controller, Delete, Get, Param, Patch, Post, Query, UseGuards } from "@nestjs/common";
import { ApiBearerAuth, ApiTags } from "@nestjs/swagger";
import { AuthGuard } from "@nestjs/passport";
import { Roles } from "../../common/roles.decorator";
import { RolesGuard } from "../../common/roles.guard";
import { CreateStudentDto } from "./dto/create-student.dto";
import { UpdateStudentDto } from "./dto/update-student.dto";
import { StudentsService } from "./students.service";

@ApiTags("students")
@ApiBearerAuth()
@UseGuards(AuthGuard("jwt"), RolesGuard)
@Controller("students")
export class StudentsController {
  constructor(private readonly students: StudentsService) {}

  @Get()
  @Roles("ADMIN", "SECRETARIA", "PROFESSOR", "FINANCEIRO")
  list(
    @Query("q") q?: string,
    @Query("page") page?: string,
    @Query("pageSize") pageSize?: string,
  ) {
    return this.students.list(q, page ? Number(page) : 1, pageSize ? Number(pageSize) : 20);
  }

  @Get(":id")
  @Roles("ADMIN", "SECRETARIA", "PROFESSOR", "FINANCEIRO")
  get(@Param("id") id: string) {
    return this.students.get(id);
  }

  @Post()
  @Roles("ADMIN", "SECRETARIA")
  create(@Body() dto: CreateStudentDto) {
    return this.students.create(dto);
  }

  @Patch(":id")
  @Roles("ADMIN", "SECRETARIA")
  update(@Param("id") id: string, @Body() dto: UpdateStudentDto) {
    return this.students.update(id, dto);
  }

  @Delete(":id")
  @Roles("ADMIN")
  remove(@Param("id") id: string) {
    return this.students.remove(id);
  }
}
