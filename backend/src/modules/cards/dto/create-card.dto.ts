import {
  IsString,
  IsNotEmpty,
  IsOptional,
  IsEmail,
  IsArray,
  ValidateNested,
  IsUrl,
} from 'class-validator';
import { plainToInstance, Transform, Type } from 'class-transformer';

class LinkDto {
  @IsString()
  @IsNotEmpty()
  title: string;

  @IsUrl()
  @IsNotEmpty()
  url: string;

  @IsString()
  @IsOptional()
  icon?: string;
}

class ThemeDto {
  @IsString()
  @IsOptional()
  color?: string;

  @IsString()
  @IsOptional()
  icon?: string;
}

export class CreateCardDto {
  @IsString()
  @IsNotEmpty()
  cardName: string;

  @IsString()
  @IsNotEmpty()
  ownerName: string;

  @ValidateNested()
  @Type(() => ThemeDto)
  @Transform(({ value }) => {
    if (typeof value === 'string') {
      try {
        const parsed = JSON.parse(value);
        return plainToInstance(ThemeDto, parsed);
      } catch {
        return undefined;
      }
    }
    return plainToInstance(ThemeDto, value);
  })
  @IsOptional()
  theme?: ThemeDto;

  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => LinkDto)
  @Transform(({ value }) => {
    if (typeof value === 'string') {
      try {
        const parsed = JSON.parse(value);
        const arrayValue = Array.isArray(parsed) ? parsed : [parsed];
        return arrayValue.map((item) => plainToInstance(LinkDto, item));
      } catch {
        return undefined;
      }
    }
    if (Array.isArray(value)) {
      return value.map((item) => plainToInstance(LinkDto, item));
    }
    return [plainToInstance(LinkDto, value)];
  })
  @IsOptional()
  links?: LinkDto[];

  @IsString()
  @IsOptional()
  address?: string;

  @IsString()
  @IsOptional()
  company?: string;

  @IsString()
  @IsOptional()
  description?: string;

  @IsString()
  @IsOptional()
  phoneNumber?: string;

  @IsEmail()
  @IsOptional()
  email?: string;
}
