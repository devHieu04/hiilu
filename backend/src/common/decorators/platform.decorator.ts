import { createParamDecorator, ExecutionContext } from '@nestjs/common';
import { PlatformType } from '../../modules/auth/schemas/login-history.schema';

export const Platform = createParamDecorator(
  (data: unknown, ctx: ExecutionContext): PlatformType => {
    const request = ctx.switchToHttp().getRequest();
    return detectPlatform(request);
  },
);

export function detectPlatform(request: any): PlatformType {
  const userAgent = request.headers['user-agent']?.toLowerCase() || '';
  const platformHeader = request.headers['x-platform']?.toLowerCase();

  // Check custom header first
  if (platformHeader) {
    switch (platformHeader) {
      case 'ios':
      case 'mobile_ios':
        return PlatformType.MOBILE_IOS;
      case 'android':
      case 'mobile_android':
        return PlatformType.MOBILE_ANDROID;
      case 'web':
        return PlatformType.WEB;
      case 'desktop':
        return PlatformType.DESKTOP;
      case 'tablet':
        return PlatformType.TABLET;
    }
  }

  // Detect from user agent
  if (userAgent.includes('iphone') || userAgent.includes('ipad')) {
    return userAgent.includes('ipad')
      ? PlatformType.TABLET
      : PlatformType.MOBILE_IOS;
  }

  if (userAgent.includes('android')) {
    return userAgent.includes('tablet')
      ? PlatformType.TABLET
      : PlatformType.MOBILE_ANDROID;
  }

  if (userAgent.includes('mobile')) {
    return PlatformType.MOBILE_IOS;
  }

  if (
    userAgent.includes('electron') ||
    userAgent.includes('windows') ||
    userAgent.includes('mac os')
  ) {
    return PlatformType.DESKTOP;
  }

  return PlatformType.WEB;
}
