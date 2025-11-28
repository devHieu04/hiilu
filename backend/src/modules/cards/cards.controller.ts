import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  UseGuards,
  HttpCode,
  HttpStatus,
  UseInterceptors,
  UploadedFiles,
} from '@nestjs/common';
import { FileFieldsInterceptor } from '@nestjs/platform-express';
import { CardsService } from './cards.service';
import { CreateCardDto } from './dto/create-card.dto';
import { UpdateCardDto } from './dto/update-card.dto';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { CurrentUser } from '../../common/decorators/current-user.decorator';
import { UserDocument } from '../users/schemas/user.schema';
import { avatarUploadConfig, coverUploadConfig } from '../../common/config/multer.config';

@Controller('cards')
export class CardsController {
  constructor(private readonly cardsService: CardsService) {}

  @Post()
  @UseGuards(JwtAuthGuard)
  @UseInterceptors(
    FileFieldsInterceptor(
      [
        { name: 'avatar', maxCount: 1 },
        { name: 'coverImage', maxCount: 1 },
      ],
      {
        storage: avatarUploadConfig.storage,
        fileFilter: avatarUploadConfig.fileFilter,
        limits: { fileSize: 5 * 1024 * 1024 }, // 5MB max
      },
    ),
  )
  create(
    @CurrentUser() user: UserDocument,
    @Body() createCardDto: CreateCardDto,
    @UploadedFiles()
    files: {
      avatar?: Express.Multer.File[];
      coverImage?: Express.Multer.File[];
    },
  ) {
    return this.cardsService.create(user._id.toString(), createCardDto, files);
  }

  @Get()
  @UseGuards(JwtAuthGuard)
  findAll(@CurrentUser() user: UserDocument) {
    return this.cardsService.findAll(user._id.toString());
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    // Public endpoint - anyone can view a card
    return this.cardsService.findOne(id);
  }

  @Patch(':id')
  @UseGuards(JwtAuthGuard)
  @UseInterceptors(
    FileFieldsInterceptor(
      [
        { name: 'avatar', maxCount: 1 },
        { name: 'coverImage', maxCount: 1 },
      ],
      {
        storage: avatarUploadConfig.storage,
        fileFilter: avatarUploadConfig.fileFilter,
        limits: { fileSize: 5 * 1024 * 1024 }, // 5MB max
      },
    ),
  )
  update(
    @Param('id') id: string,
    @CurrentUser() user: UserDocument,
    @Body() updateCardDto: UpdateCardDto,
    @UploadedFiles()
    files: {
      avatar?: Express.Multer.File[];
      coverImage?: Express.Multer.File[];
    },
  ) {
    return this.cardsService.update(id, user._id.toString(), updateCardDto, files);
  }

  @Delete(':id')
  @UseGuards(JwtAuthGuard)
  @HttpCode(HttpStatus.OK)
  remove(@Param('id') id: string, @CurrentUser() user: UserDocument) {
    return this.cardsService.remove(id, user._id.toString());
  }

  @Post(':id/regenerate-qr')
  @UseGuards(JwtAuthGuard)
  regenerateQR(@Param('id') id: string, @CurrentUser() user: UserDocument) {
    return this.cardsService.regenerateQRCode(id, user._id.toString());
  }
}
