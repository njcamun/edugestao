import { Controller, Get, Post, Body, Param, Query, UseGuards } from '@nestjs/common';
import { ApiTags, ApiBearerAuth, ApiOperation, ApiQuery } from '@nestjs/swagger';
import { FinanceService } from './finance.service';
import { CreateInvoiceDto } from './dto/create-invoice.dto';
import { CreatePaymentDto } from './dto/create-payment.dto';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { RolesGuard } from '../../common/roles.guard';
import { Roles } from '../../common/roles.decorator';

@ApiTags('finance')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Controller('finance')
export class FinanceController {
  constructor(private readonly service: FinanceService) {}

  @Post('invoices')
  @Roles('ADMIN', 'FINANCEIRO')
  @ApiOperation({ summary: 'Criar uma nova cobrança' })
  createInvoice(@Body() dto: CreateInvoiceDto) {
    return this.service.createInvoice(dto);
  }

  @Get('invoices')
  @Roles('ADMIN', 'FINANCEIRO', 'SECRETARIA')
  @ApiOperation({ summary: 'Listar cobranças' })
  @ApiQuery({ name: 'enrollmentId', required: false })
  findAllInvoices(@Query('enrollmentId') enrollmentId?: string) {
    return this.service.findAllInvoices(enrollmentId);
  }

  @Get('invoices/:id')
  @Roles('ADMIN', 'FINANCEIRO', 'SECRETARIA')
  @ApiOperation({ summary: 'Obter detalhe de uma cobrança' })
  findInvoice(@Param('id') id: string) {
    return this.service.findInvoice(id);
  }

  @Post('payments')
  @Roles('ADMIN', 'FINANCEIRO')
  @ApiOperation({ summary: 'Registar um pagamento' })
  createPayment(@Body() dto: CreatePaymentDto) {
    return this.service.createPayment(dto);
  }

  @Get('dashboard')
  @Roles('ADMIN', 'FINANCEIRO')
  @ApiOperation({ summary: 'Obter estatísticas financeiras para o dashboard' })
  getDashboardStats() {
    return this.service.getDashboardStats();
  }
}
