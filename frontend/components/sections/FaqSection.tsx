'use client';

import { useState } from 'react';

const faqs = [
  {
    question: 'HiiLu là gì?',
    answer:
      'HiiLu là nền tảng tạo và chia sẻ thẻ cá nhân thông minh tại Việt Nam. Bạn có thể tạo danh thiếp số hiện đại, chia sẻ thông tin liên hệ chỉ với một lần chạm hoặc quét mã QR, không cần kết nối mạng.',
  },
  {
    question: 'Làm thế nào để sử dụng HiiLu?',
    answer:
      'Việc sử dụng HiiLu rất đơn giản. Bạn chỉ cần đăng ký tài khoản trên website, tạo danh thiếp với thông tin của mình, và tải ứng dụng HiiLu để đồng bộ. Sau đó bạn có thể chia sẻ thẻ của mình với mọi người một cách dễ dàng.',
  },
  {
    question: 'Thông tin của tôi có an toàn không?',
    answer:
      'Có, HiiLu cam kết bảo mật thông tin của bạn. Tất cả dữ liệu đều được mã hóa và lưu trữ an toàn. Bạn có toàn quyền kiểm soát thông tin nào được chia sẻ và có thể cập nhật hoặc xóa bất cứ lúc nào.',
  },
  {
    question: 'HiiLu có miễn phí không?',
    answer:
      'HiiLu cung cấp gói miễn phí với đầy đủ tính năng cơ bản để bạn tạo và chia sẻ danh thiếp số. Ngoài ra, chúng tôi cũng có các gói nâng cao với nhiều tính năng bổ sung cho doanh nghiệp và người dùng chuyên nghiệp.',
  },
];

export function FaqSection() {
  const [openIndex, setOpenIndex] = useState<number | null>(null);

  const toggleQuestion = (index: number) => {
    setOpenIndex(openIndex === index ? null : index);
  };

  return (
    <section id="faq" className="w-full bg-white pt-[80px] pb-8 sm:pt-[63px] sm:pb-12">
      <div className="container-default">
        <div className="mx-auto max-w-3xl text-center">
          <p className="text-3xl font-semibold uppercase text-[#455A6B] sm:text-4xl md:text-5xl lg:text-[56px]">
            Giải đáp thắc mắc
          </p>
          <p className="mt-2 text-base leading-relaxed text-[#4a4a4a] sm:text-lg">
            Tìm câu trả lời cho những thắc mắc thường gặp về HiiLu. Chúng tôi luôn sẵn sàng
            hỗ trợ bạn trong hành trình số hoá danh thiếp.
          </p>
        </div>

        <div className="mt-8 space-y-3 sm:mt-12 sm:space-y-4">
          {faqs.map((faq, index) => (
            <article
              key={index}
              className="overflow-hidden rounded-[20px] border border-white/70 bg-white shadow-[0_15px_50px_rgba(15,23,42,0.08)] transition-all sm:rounded-[24px]"
            >
              <button
                onClick={() => toggleQuestion(index)}
                className="flex w-full items-center gap-3 px-4 py-4 text-left text-sm font-semibold text-[#1f1f1f] transition-colors hover:bg-gray-50 sm:gap-4 sm:px-6 sm:py-5 sm:text-base"
              >
                <span className="flex h-8 w-8 shrink-0 items-center justify-center rounded-full bg-[#eff3ff] text-xs font-bold text-[#5061c9] sm:h-10 sm:w-10 sm:text-sm">
                  0{index + 1}
                </span>
                <span className="min-w-0 flex-1">{faq.question}</span>
                <span
                  className={`material-icons shrink-0 text-[#5061c9] transition-transform ${
                    openIndex === index ? 'rotate-180' : ''
                  }`}
                >
                  expand_more
                </span>
              </button>
              {openIndex === index && (
                <div className="px-4 pb-4 sm:px-6 sm:pb-5">
                  <div className="ml-0 border-t border-gray-100 pt-4 sm:ml-14">
                    <p className="text-sm leading-relaxed text-[#5a5a5a] sm:text-base">
                      {faq.answer}
                    </p>
                  </div>
                </div>
              )}
            </article>
          ))}
        </div>
      </div>
    </section>
  );
}
