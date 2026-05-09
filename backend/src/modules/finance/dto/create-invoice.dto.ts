import { IsNotEmpty, IsString, IsNumber, IsDateString, IsOptional, IsEnum } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';
import { InvoiceStatus } from '@prisma/client';

export class CreateInvoiceDto {
  @ApiProperty()
  @IsString()
  @IsNotEmpty()
  enrollmentId!: string;

  @ApiProperty({ example: 'Propina de Março' })
  @IsString()
  @IsNotEmpty()
  description!: string;

  @ApiProperty({ example: 10000 })
  @IsNumber()
  amount!: number;

  @ApiProperty({ example: '2025-03-31' })
  @IsDateString()
  @IsNotEmpty()
  dueDate!: string;

  @ApiProperty({ enum: InvoiceStatus, default: InvoiceStatus.PENDENTE, required: false })
  @IsEnum(InvoiceStatus)
  @IsOptional()
  status?: InvoiceStatus;
}
