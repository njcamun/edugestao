import { IsNotEmpty, IsString, IsNumber, IsEnum, IsOptional, IsDateString } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';
import { PaymentMethod } from '@prisma/client';

export class CreatePaymentDto {
  @ApiProperty()
  @IsString()
  @IsNotEmpty()
  invoiceId: string;

  @ApiProperty({ example: 5000 })
  @IsNumber()
  amountPaid: number;

  @ApiProperty({ enum: PaymentMethod, default: PaymentMethod.DINHEIRO })
  @IsEnum(PaymentMethod)
  paymentMethod: PaymentMethod;

  @ApiProperty({ example: '2025-03-15', required: false })
  @IsDateString()
  @IsOptional()
  paymentDate?: string;
}
