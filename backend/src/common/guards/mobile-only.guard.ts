import { Injectable, CanActivate, ExecutionContext, ForbiddenException } from '@nestjs/common';
import { detectPlatform } from '../decorators/platform.decorator';
import { PlatformType } from '../../modules/auth/schemas/login-history.schema';

@Injectable()
export class MobileOnlyGuard implements CanActivate {
  canActivate(context: ExecutionContext): boolean {
    const request = context.switchToHttp().getRequest();
    const platform = detectPlatform(request);

    const isMobile =
      platform === PlatformType.MOBILE_IOS ||
      platform === PlatformType.MOBILE_ANDROID;

    if (!isMobile) {
      throw new ForbiddenException('This endpoint is only accessible on mobile devices');
    }

    return true;
  }
}
