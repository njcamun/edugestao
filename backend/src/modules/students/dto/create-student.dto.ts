import { IsOptional, IsString, MinLength } from "class-validator";

export class CreateStudentDto {
  @IsString()
  @MinLength(3)
  fullName!: string;

  @IsOptional()
  @IsString()
  phone?: string;

  @IsOptional()
  @IsString()
  address?: string;
}
