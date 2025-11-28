import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document, Types } from 'mongoose';

export type LoginHistoryDocument = LoginHistory & Document;

export enum PlatformType {
  WEB = 'web',
  MOBILE_IOS = 'mobile_ios',
  MOBILE_ANDROID = 'mobile_android',
  TABLET = 'tablet',
  DESKTOP = 'desktop',
  UNKNOWN = 'unknown',
}

@Schema({ timestamps: true })
export class LoginHistory {
  @Prop({ type: Types.ObjectId, ref: 'User', required: true, index: true })
  userId: Types.ObjectId;

  @Prop({ required: true, enum: PlatformType, default: PlatformType.WEB })
  platform: PlatformType;

  @Prop()
  ipAddress?: string;

  @Prop()
  userAgent?: string;

  @Prop()
  deviceInfo?: string;

  @Prop()
  location?: string;

  @Prop({ default: true })
  isSuccessful: boolean;

  @Prop()
  failureReason?: string;

  @Prop()
  createdAt: Date;
}

export const LoginHistorySchema =
  SchemaFactory.createForClass(LoginHistory);

// Indexes
LoginHistorySchema.index({ userId: 1, createdAt: -1 });
LoginHistorySchema.index({ platform: 1 });
LoginHistorySchema.index({ createdAt: -1 });
