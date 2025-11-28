'use client';

import Image from 'next/image';
import { CreateCardRequest } from '@/lib/cards';

interface CardPreviewProps {
  cardData: Partial<CreateCardRequest>;
  avatarPreview?: string;
  coverImagePreview?: string;
}

// Helper function to detect link type and get icon
const getLinkIcon = (url: string, customIcon?: string): string => {
  if (customIcon) return customIcon;

  const lowerUrl = url.toLowerCase();
  if (lowerUrl.includes('github.com')) return 'code';
  if (lowerUrl.includes('linkedin.com')) return 'work';
  if (lowerUrl.includes('facebook.com') || lowerUrl.includes('fb.com')) return 'facebook';
  if (lowerUrl.includes('zalo.me') || lowerUrl.includes('zalo')) return 'chat';
  if (lowerUrl.includes('twitter.com') || lowerUrl.includes('x.com')) return 'tag';
  if (lowerUrl.includes('instagram.com')) return 'photo_camera';
  if (lowerUrl.includes('youtube.com')) return 'play_circle';
  if (lowerUrl.includes('tiktok.com')) return 'music_note';
  if (lowerUrl.includes('behance.net')) return 'palette';
  if (lowerUrl.includes('dribbble.com')) return 'sports_basketball';
  return 'link';
};

export function CardPreview({
  cardData,
  avatarPreview,
  coverImagePreview,
}: CardPreviewProps) {
  const themeColor = cardData.theme?.color || '#0ea5e9';
  const getInitials = (name?: string) => {
    if (!name) return '?';
    return name
      .split(' ')
      .map((n) => n[0])
      .join('')
      .toUpperCase()
      .slice(0, 2);
  };

  return (
    <div className="sticky top-8 flex justify-center">
      <div className="relative h-[600px] w-[320px] rounded-[40px] border-[12px] border-gray-800 bg-gray-900 shadow-2xl">
        {/* Phone notch */}
        <div className="absolute left-1/2 top-0 h-6 w-32 -translate-x-1/2 rounded-b-2xl bg-gray-900"></div>

        {/* Screen content */}
        <div className="flex h-full flex-col overflow-y-auto rounded-[28px] bg-white">
          {/* Top Background Section */}
          <div
            className="relative h-40 w-full"
            style={{
              backgroundColor: coverImagePreview || cardData.coverImageUrl
                ? 'transparent'
                : cardData.theme?.color || '#fef3c7',
            }}
          >
            {coverImagePreview || cardData.coverImageUrl ? (
              <img
                src={coverImagePreview || cardData.coverImageUrl}
                alt="Cover"
                className="h-full w-full object-cover"
              />
            ) : null}

            {/* Avatar - overlapping */}
            <div className="absolute left-1/2 top-full -translate-x-1/2 -translate-y-1/2">
              {avatarPreview || cardData.avatarUrl ? (
                <div className="h-28 w-28 rounded-full border-4 border-white shadow-lg overflow-hidden">
                  <img
                    src={avatarPreview || cardData.avatarUrl}
                    alt={cardData.ownerName || 'Avatar'}
                    className="h-full w-full object-cover"
                  />
                </div>
              ) : (
                <div
                  className="flex h-28 w-28 items-center justify-center rounded-full border-4 border-white text-3xl font-semibold text-white shadow-lg"
                  style={{ backgroundColor: themeColor }}
                >
                  {getInitials(cardData.ownerName)}
                </div>
              )}
            </div>
          </div>

          {/* Main Content */}
          <div className="flex flex-1 flex-col items-center px-6 pt-16 pb-6">
            {/* Name */}
            <h2 className="mb-2 text-center text-xl font-semibold text-gray-900">
              {cardData.ownerName || 'Tên của bạn'}
            </h2>

            {/* Description/Job */}
            {cardData.description && (
              <p className="mb-1 text-center text-sm text-gray-600">{cardData.description}</p>
            )}

            {/* Company */}
            {cardData.company && (
              <p className="mb-2 text-center text-sm text-gray-500">{cardData.company}</p>
            )}

            {/* Address */}
            {cardData.address && (
              <p className="mb-6 text-center text-sm text-gray-600">{cardData.address}</p>
            )}

            {/* Contact Button */}
            <button
              className="mb-6 w-full rounded-lg px-6 py-3 text-sm font-semibold text-white transition-all hover:opacity-90"
              style={{ backgroundColor: cardData.theme?.color || '#fbbf24' }}
            >
              Liên hệ ngay
            </button>

            {/* Contact Info List */}
            <div className="mb-4 w-full space-y-3">
              {cardData.email && (
                <a
                  href={`mailto:${cardData.email}`}
                  className="flex items-center gap-3 rounded-lg px-3 py-2.5 transition-all hover:bg-gray-50"
                >
                  <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-gradient-to-br from-blue-400 to-blue-500">
                    <span className="material-icons text-lg text-white">email</span>
                  </div>
                  <span className="flex-1 text-sm font-medium text-gray-900">Mail</span>
                </a>
              )}

              {cardData.phoneNumber && (
                <a
                  href={`tel:${cardData.phoneNumber}`}
                  className="flex items-center gap-3 rounded-lg px-3 py-2.5 transition-all hover:bg-gray-50"
                >
                  <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-gradient-to-br from-green-400 to-green-500">
                    <span className="material-icons text-lg text-white">phone</span>
                  </div>
                  <span className="flex-1 text-sm font-medium text-gray-900">Số điện thoại</span>
                </a>
              )}
            </div>

            {/* Links List */}
            {cardData.links && cardData.links.length > 0 && (
              <div className="w-full space-y-3">
                {cardData.links.map((link, index) => {
                  const linkIcon = getLinkIcon(link.url, link.icon);
                  // Determine gradient color based on link type
                  const getLinkGradient = (url: string) => {
                    const lowerUrl = url.toLowerCase();
                    if (lowerUrl.includes('github.com')) return 'from-gray-600 to-gray-700';
                    if (lowerUrl.includes('linkedin.com')) return 'from-blue-500 to-blue-600';
                    if (lowerUrl.includes('facebook.com') || lowerUrl.includes('fb.com'))
                      return 'from-blue-600 to-blue-700';
                    if (lowerUrl.includes('zalo.me') || lowerUrl.includes('zalo'))
                      return 'from-blue-400 to-blue-500';
                    if (lowerUrl.includes('twitter.com') || lowerUrl.includes('x.com'))
                      return 'from-sky-400 to-sky-500';
                    if (lowerUrl.includes('instagram.com')) return 'from-pink-500 to-pink-600';
                    if (lowerUrl.includes('youtube.com')) return 'from-red-500 to-red-600';
                    return 'from-gray-400 to-gray-500';
                  };

                  return (
                    <a
                      key={index}
                      href={link.url}
                      target="_blank"
                      rel="noopener noreferrer"
                      className="flex items-center gap-3 rounded-lg px-3 py-2.5 transition-all hover:bg-gray-50"
                    >
                      <div
                        className={`flex h-10 w-10 items-center justify-center rounded-lg bg-gradient-to-br ${getLinkGradient(link.url)}`}
                      >
                        <span className="material-icons text-lg text-white">{linkIcon}</span>
                      </div>
                      <span className="flex-1 text-sm font-medium text-gray-900">
                        {link.title}
                      </span>
                    </a>
                  );
                })}
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  );
}
