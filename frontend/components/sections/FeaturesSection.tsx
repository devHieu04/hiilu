'use client';

import Image from 'next/image';
import { useRouter } from 'next/navigation';
import { useAuth } from '@/contexts/AuthContext';

const featureCards = [
  {
    title: 'Tùy chỉnh giao diện',
    description:
      'Thoả sức sáng tạo với nhiều lựa chọn màu sắc, phong cách để danh thiếp của bạn trở nên chuyên nghiệp hơn bao giờ hết.',
    icon: '/assets/web/layout (1).png',
    // accent: '#dff5ec',
  },
  {
    title: 'Cập nhật thông tin',
    description:
      'Bạn có thể chỉnh sửa hoặc bổ sung thông tin cá nhân chỉ trong vài thao tác. Tất cả thay đổi sẽ được đồng bộ ngay trên danh thiếp của bạn.',
    icon: '/assets/web/user.png',
    // accent: '#e8f0ff',
  },
  {
    title: 'Thẻ thông minh',
    description:
      'Chia sẻ thông tin liên hệ chỉ bằng một lần chạm hoặc một lần quét – không cần app, không cần kết nối mạng.',
    icon: '/assets/web/id-card.png',
    // accent: '#fdebf3',
  },
  {
    title: 'Gửi lời nhắn',
    description:
      'Người khác có thể để lại thông tin và lời nhắn cho bạn sau khi chạm thẻ. Mọi tương tác đều được lưu lại để bạn kết nối và phản hồi.',
    icon: '/assets/web/chat (3).png',
    // accent: '#fff5df',
  },
  {
    title: 'Liên kết bio',
    description:
      'Tổng hợp tất cả link quan trọng của bạn: Facebook, Instagram, Zalo, LinkedIn, portfolio... trong một trang duy nhất.',
    icon: '/assets/web/link.png',
    // accent: '#e9ecff',
  },
  {
    title: 'Hỗ trợ tận tâm 24/7',
    description:
      'Đội ngũ HiiLu luôn đồng hành cùng bạn, sẵn sàng hướng dẫn và giải quyết mọi khó khăn trong quá trình sử dụng thẻ.',
    icon: '/assets/web/personalized-support.png',
    // accent: '#e6f6ff',
  },
];

export function FeaturesSection() {
  const { user } = useAuth();
  const router = useRouter();
  
  return (
    <section id="features" className="w-full py-8 sm:py-12">
      <div className="container-default">
        <div className="mx-auto max-w-3xl text-center">
          <p className="text-3xl font-semibold uppercase text-[#455A6B] sm:text-4xl md:text-5xl lg:text-[56px]">
            Tính năng của HiiLu
          </p>
          <p className="mt-4 text-base leading-relaxed text-[#4a4a4a] sm:text-lg">
            Khám phá những tính năng mạnh mẽ giúp bạn tạo ra danh thiếp số chuyên nghiệp,
            kết nối hiệu quả và quản lý thông tin một cách thông minh.
          </p>
        </div>

        {/* Hero section with image and CTA */}
        <div className="mt-10 rounded-[16px] border border-[#e0d5ff] bg-white p-6 sm:mt-14 sm:rounded-[20px] sm:p-8 md:p-12">
          <div className="grid gap-6 md:grid-cols-2 md:items-center md:gap-8">
            <div className="space-y-4 sm:space-y-6">
              <p className="text-xl font-semibold leading-tight text-[#455A6B] sm:text-2xl md:text-3xl">
                Thật tuyệt vời khi chỉ với một thao tác, mọi thông tin đều sẵn sàng.
              </p>
              {/* <button className="group flex w-full items-center overflow-hidden rounded-full bg-[#e9d5ff] transition-all hover:shadow-lg sm:w-auto">
                <div className="flex h-full items-center justify-center rounded-full bg-[#8b5cf6] p-3 transition-all group-hover:bg-[#7c3aed] sm:p-4">
                  <svg
                    className="h-4 w-4 text-white transition-transform group-hover:translate-x-1 sm:h-5 sm:w-5"
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                  >
                    <path
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      strokeWidth={2}
                      d="M13 7l5 5m0 0l-5 5m5-5H6"
                    />
                  </svg>
                </div>
                <span className="px-6 py-3 text-sm font-semibold text-[#8b5cf6] transition-colors group-hover:text-[#7c3aed] sm:px-8 sm:py-4 sm:text-base">
                  Khám phá ngay
                </span>
              </button> */}
              <button
  onClick={() => {
    user ? router.push('/dashboard') : router.push("/login");
  }}
  className="group flex w-full items-center overflow-hidden rounded-full bg-[#e9d5ff] transition-all hover:shadow-lg sm:w-auto"
>
  <div className="flex h-full items-center justify-center rounded-full bg-[#8b5cf6] p-3 transition-all group-hover:bg-[#7c3aed] sm:p-4">
                  <svg
                    className="h-4 w-4 text-white transition-transform group-hover:translate-x-1 sm:h-5 sm:w-5"
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                  >
                    <path
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      strokeWidth={2}
                      d="M13 7l5 5m0 0l-5 5m5-5H6"
                    />
                  </svg>
                </div>
                <span className="px-6 py-3 text-sm font-semibold text-[#4F4B6F] transition-colors group-hover:text-[#7c3aed] sm:px-8 sm:py-4 sm:text-base">
                  Khám phá ngay
                </span>
</button>

            </div>
            <div className="relative flex items-center justify-center">
              <Image
                src="/assets/web/featureuser.png"
                alt="Người dùng cầm thẻ HiiLu"
                width={600}
                height={600}
                className="h-auto w-full max-w-[280px] object-contain sm:max-w-md"
                priority
              />
            </div>
          </div>
        </div>

        {/* Feature cards grid */}
        <div className="mt-10 grid gap-6 sm:mt-14 sm:gap-8 sm:grid-cols-2 lg:grid-cols-3">
          {featureCards.map((feature) => (
            <article
              key={feature.title}
              className="card-surface hover-card rounded-[24px] bg-white p-6 text-left sm:rounded-[28px] sm:p-8"
            >
              <div
                className="mb-4 flex h-14 w-14 items-center justify-center rounded-2xl sm:mb-6 sm:h-16 sm:w-16"
                // style={{ backgroundColor: feature.accent }}
              >
                <Image
                  src={feature.icon}
                  alt={feature.title}
                  width={40}
                  height={40}
                  className="h-8 w-8 object-contain sm:h-10 sm:w-10"
                />
              </div>
              <h3 className="text-lg font-semibold text-[#1a1a1a] sm:text-xl">
                {feature.title}
              </h3>
              <p className="mt-2 text-sm leading-relaxed text-[#4a4a4a] sm:text-base">
                {feature.description}
              </p>
            </article>
          ))}
        </div>
      </div>
    </section>
  );
}
