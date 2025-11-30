import { NestFactory } from '@nestjs/core';
import { AppModule } from '../app.module';
import { Model } from 'mongoose';
import { getModelToken } from '@nestjs/mongoose';
import { Card, CardDocument } from '../modules/cards/schemas/card.schema';
import { randomUUID } from 'crypto';

async function seedCardUuids() {
  const app = await NestFactory.createApplicationContext(AppModule);

  try {
    const cardModel = app.get<Model<CardDocument>>(getModelToken(Card.name));

    console.log('🔍 Đang tìm các card chưa có UUID...');

    // Find all cards without shareUuid
    const cardsWithoutUuid = await cardModel.find({
      $or: [
        { shareUuid: { $exists: false } },
        { shareUuid: null },
        { shareUuid: '' },
      ],
    });

    console.log(`📊 Tìm thấy ${cardsWithoutUuid.length} card(s) chưa có UUID`);

    if (cardsWithoutUuid.length === 0) {
      console.log('✅ Tất cả cards đã có UUID!');
      await app.close();
      process.exit(0);
    }

    console.log('🔄 Đang cập nhật UUID cho các cards...');

    let updatedCount = 0;
    for (const card of cardsWithoutUuid) {
      card.shareUuid = randomUUID();
      await card.save();
      updatedCount++;
      console.log(
        `  ✓ Card ${card._id} - ${card.cardName || card.ownerName}: ${card.shareUuid}`,
      );
    }

    console.log(`\n✅ Đã cập nhật UUID cho ${updatedCount} card(s)!`);
    console.log('🎉 Hoàn tất seed!');
  } catch (error) {
    console.error('❌ Lỗi khi seed:', error);
    process.exit(1);
  } finally {
    await app.close();
    process.exit(0);
  }
}

seedCardUuids();
