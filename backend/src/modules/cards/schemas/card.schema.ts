import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document, Types } from 'mongoose';

export type CardDocument = Card & Document;

class Link {
  @Prop({ required: true })
  title: string;

  @Prop({ required: true })
  url: string;

  @Prop()
  icon?: string;
}

class Theme {
  @Prop({ default: '#0ea5e9' })
  color: string;

  @Prop()
  icon?: string;
}

@Schema({ timestamps: true })
export class Card {
  @Prop({ type: Types.ObjectId, ref: 'User', required: true, index: true })
  userId: Types.ObjectId;

  @Prop({ required: true, trim: true })
  cardName: string;

  @Prop({ required: true, trim: true })
  ownerName: string;

  @Prop()
  avatarUrl?: string;

  @Prop()
  coverImageUrl?: string;

  @Prop({ type: Theme, default: () => ({}) })
  theme: Theme;

  @Prop({ type: [Link], default: [] })
  links: Link[];

  @Prop()
  address?: string;

  @Prop()
  company?: string;

  @Prop()
  description?: string;

  @Prop()
  phoneNumber?: string;

  @Prop({ lowercase: true })
  email?: string;

  @Prop()
  qrCodeUrl?: string;

  @Prop({ default: true })
  isActive: boolean;

  @Prop({ default: 0 })
  viewCount: number;

  @Prop({ unique: true, sparse: true })
  shareUuid?: string;

  @Prop()
  createdAt: Date;

  @Prop()
  updatedAt: Date;
}

export const CardSchema = SchemaFactory.createForClass(Card);

// Indexes for better query performance
CardSchema.index({ userId: 1, createdAt: -1 });
CardSchema.index({ isActive: 1 });
CardSchema.index({ shareUuid: 1 });
