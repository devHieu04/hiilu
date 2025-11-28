import {
  Injectable,
  NotFoundException,
  ForbiddenException,
} from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import * as QRCode from 'qrcode';
import { Card, CardDocument } from './schemas/card.schema';
import { CreateCardDto } from './dto/create-card.dto';
import { UpdateCardDto } from './dto/update-card.dto';
import { ConfigService } from '@nestjs/config';
import { FileUtil } from '../../common/utils/file.util';

@Injectable()
export class CardsService {
  constructor(
    @InjectModel(Card.name) private cardModel: Model<CardDocument>,
    private configService: ConfigService,
  ) {}

  async create(
    userId: string,
    createCardDto: CreateCardDto,
    files?: {
      avatar?: Express.Multer.File[];
      coverImage?: Express.Multer.File[];
    },
  ) {
    const card = new this.cardModel({
      ...createCardDto,
      userId,
    });

    // Save file paths if files were uploaded
    if (files?.avatar && files.avatar[0]) {
      card.avatarUrl = files.avatar[0].path;
    }
    if (files?.coverImage && files.coverImage[0]) {
      card.coverImageUrl = files.coverImage[0].path;
    }

    const savedCard = await card.save();

    // Generate QR code
    const qrCodeUrl = await this.generateQRCode(savedCard._id.toString());
    savedCard.qrCodeUrl = qrCodeUrl;
    await savedCard.save();

    return this.transformCardUrls(savedCard);
  }

  async findAll(userId: string) {
    const cards = await this.cardModel
      .find({ userId, isActive: true })
      .sort({ createdAt: -1 })
      .exec();

    return cards.map((card) => this.transformCardUrls(card));
  }

  async findOne(id: string, userId?: string) {
    const card = await this.cardModel.findById(id);

    if (!card) {
      throw new NotFoundException('Card not found');
    }

    // Increment view count if not owner
    if (!userId || card.userId.toString() !== userId) {
      card.viewCount += 1;
      await card.save();
    }

    return this.transformCardUrls(card);
  }

  async update(
    id: string,
    userId: string,
    updateCardDto: UpdateCardDto,
    files?: {
      avatar?: Express.Multer.File[];
      coverImage?: Express.Multer.File[];
    },
  ) {
    const card = await this.cardModel.findById(id);

    if (!card) {
      throw new NotFoundException('Card not found');
    }

    if (card.userId.toString() !== userId) {
      throw new ForbiddenException('You do not have permission to update this card');
    }

    // Handle avatar file replacement
    if (files?.avatar && files.avatar[0]) {
      // Delete old avatar if exists
      if (card.avatarUrl) {
        await FileUtil.deleteFile(card.avatarUrl);
      }
      card.avatarUrl = files.avatar[0].path;
    }

    // Handle cover image file replacement
    if (files?.coverImage && files.coverImage[0]) {
      // Delete old cover image if exists
      if (card.coverImageUrl) {
        await FileUtil.deleteFile(card.coverImageUrl);
      }
      card.coverImageUrl = files.coverImage[0].path;
    }

    Object.assign(card, updateCardDto);
    const updatedCard = await card.save();
    return this.transformCardUrls(updatedCard);
  }

  async remove(id: string, userId: string) {
    const card = await this.cardModel.findById(id);

    if (!card) {
      throw new NotFoundException('Card not found');
    }

    if (card.userId.toString() !== userId) {
      throw new ForbiddenException('You do not have permission to delete this card');
    }

    // Delete files
    if (card.avatarUrl) {
      await FileUtil.deleteFile(card.avatarUrl);
    }
    if (card.coverImageUrl) {
      await FileUtil.deleteFile(card.coverImageUrl);
    }

    // Soft delete
    card.isActive = false;
    await card.save();

    return { message: 'Card deleted successfully' };
  }

  private async generateQRCode(cardId: string): Promise<string> {
    try {
      const appUrl = this.configService.get<string>('NEXT_PUBLIC_APP_URL') || 'http://localhost:8081';
      const cardUrl = `${appUrl}/card/${cardId}`;

      // Generate QR code as data URL
      const qrCodeDataUrl = await QRCode.toDataURL(cardUrl, {
        errorCorrectionLevel: 'H',
        margin: 1,
        width: 512,
        color: {
          dark: '#000000',
          light: '#FFFFFF',
        },
      });

      return qrCodeDataUrl;
    } catch (error) {
      console.error('Error generating QR code:', error);
      return '';
    }
  }

  async regenerateQRCode(id: string, userId: string) {
    const card = await this.cardModel.findById(id);

    if (!card) {
      throw new NotFoundException('Card not found');
    }

    if (card.userId.toString() !== userId) {
      throw new ForbiddenException('You do not have permission to update this card');
    }

    const qrCodeUrl = await this.generateQRCode(card._id.toString());
    card.qrCodeUrl = qrCodeUrl;
    await card.save();

    return this.transformCardUrls(card);
  }

  /**
   * Transform file paths to full URLs
   */
  private transformCardUrls(card: CardDocument): any {
    const cardObject = card.toObject();
    const fileBaseUrl =
      this.configService.get<string>('FILE_BASE_URL') ||
      this.configService.get<string>('BACKEND_PUBLIC_URL') ||
      'http://localhost:8080';

    if (cardObject.avatarUrl) {
      cardObject.avatarUrl = `${fileBaseUrl}/${cardObject.avatarUrl}`;
    }
    if (cardObject.coverImageUrl) {
      cardObject.coverImageUrl = `${fileBaseUrl}/${cardObject.coverImageUrl}`;
    }

    return cardObject;
  }
}
