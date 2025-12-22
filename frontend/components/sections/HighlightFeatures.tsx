'use client';

import Image from 'next/image';
import { useState } from 'react';

const highlightFeatures = [
  {
    title: 'Chạm để chia sẻ',
    description: 'Chia sẻ thông tin liên hệ chỉ với một lần chạm.',
    icon: '/assets/web/antenna.png',
    bgColor: 'bg-[#A8E6CF]',
  },
  {
    title: 'Kết nối nhanh',
    description: 'Kết nối bạn bè, đối tác nhanh chóng và tiện lợi.',
    icon: '/assets/web/marketing.png',
    bgColor: 'bg-[#BCAEFF]',
  },
  {
    title: 'Xây dựng thương hiệu',
    description: 'Một danh thiếp thông minh, ấn tượng chuyên nghiệp.',
    icon: '/assets/web/brand (2).png',
    bgColor: 'bg-[#F7C8E0]',
  },
];

export function HighlightFeatures() {
  const [currentIndex, setCurrentIndex] = useState(0);

  const handleNext = () => {
    setCurrentIndex((prev) => (prev + 1) % highlightFeatures.length);
  };

  const currentFeature = highlightFeatures[currentIndex];

  return (
    <div className="relative z-10 -mt-[60px] mx-auto w-full max-w-[1110px] px-4 sm:-mt-[80px] sm:px-6 md:-mt-[110px]">
      {/* Mobile/Tablet: Carousel with click */}
      <div className="relative min-h-[280px] rounded-[24px] bg-white px-4 py-6 text-center shadow-[0_30px_70px_rgba(120,126,255,0.15)] sm:min-h-[300px] sm:rounded-[36px] sm:px-6 sm:py-8 md:hidden">
        <article
          onClick={handleNext}
          className="flex cursor-pointer flex-col items-center justify-center space-y-3 rounded-[20px] border border-transparent px-3 py-4 transition-all hover:scale-105 hover:shadow-lg sm:space-y-4 sm:rounded-[28px] sm:px-6 sm:py-8"
        >
          <div
            className={`mx-auto flex h-16 w-16 items-center justify-center rounded-full ${currentFeature.bgColor} card-surface transition-all duration-300 sm:h-20 sm:w-20`}
          >
            <Image
              src={currentFeature.icon}
              alt={currentFeature.title}
              width={48}
              height={48}
              className="h-10 w-10 object-contain transition-transform duration-300 sm:h-12 sm:w-12"
            />
          </div>
          <h3 className="text-base font-semibold text-[#1a1a1a] transition-all duration-300 sm:text-lg">
            {currentFeature.title}
          </h3>
          <p className="text-xs text-[#5a5a5a] transition-all duration-300 sm:text-sm">
            {currentFeature.description}
          </p>
        </article>

        {/* Indicators - only on mobile/tablet */}
        <div className="mt-6 flex items-center justify-center gap-2">
          {highlightFeatures.map((_, index) => (
            <button
              key={index}
              onClick={() => setCurrentIndex(index)}
              className={`h-2 rounded-full transition-all duration-300 ${
                index === currentIndex
                  ? 'w-8 bg-[#8b5cf6]'
                  : 'w-2 bg-gray-300 hover:bg-gray-400'
              }`}
              aria-label={`Go to slide ${index + 1}`}
            />
          ))}
        </div>
      </div>

      {/* Desktop: Grid 3 columns (no click) */}
      <div className="hidden min-h-[300px] gap-8 rounded-[36px] bg-white px-12 py-8 text-center shadow-[0_30px_70px_rgba(120,126,255,0.15)] md:grid md:grid-cols-3">
        {highlightFeatures.map((feature) => (
          <article
            key={feature.title}
            className="flex flex-col items-center justify-center space-y-4 rounded-[28px] border border-transparent hover-card"
          >
            <div
              className={`mx-auto flex h-20 w-20 items-center justify-center rounded-full ${feature.bgColor} card-surface`}
            >
              <Image
                src={feature.icon}
                alt={feature.title}
                width={48}
                height={48}
                className="h-12 w-12 object-contain"
              />
            </div>
            <h3 className="text-lg font-semibold text-[#1a1a1a]">
              {feature.title}
            </h3>
            <p className="text-sm text-[#5a5a5a]">{feature.description}</p>
          </article>
        ))}
      </div>
    </div>
  );
}
