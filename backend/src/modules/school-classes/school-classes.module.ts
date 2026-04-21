import { Module } from '@nestjs/common';
import { SchoolClassesService } from './school-classes.service';
import { SchoolClassesController } from './school-classes.controller';
import { PrismaModule } from '../prisma/prisma.module';

@Module({
  imports: [PrismaModule],
  controllers: [SchoolClassesController],
  providers: [SchoolClassesService],
  exports: [SchoolClassesService],
})
export class SchoolClassesModule {}
