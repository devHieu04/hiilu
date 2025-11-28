const steps = [
  {
    title: 'Đăng ký tài khoản',
    description:
      'Đăng ký tài khoản trên trang web chính thức của HiiLu. Từ đó để thao tác các tiện ích khác.',
    icon: 'person_add',
  },
  {
    title: 'Tạo danh thiếp',
    description:
      'Thiết lập thẻ và điền các thông tin như tên hiển thị, ảnh đại diện cho danh thiếp của bạn.',
    icon: 'credit_card',
  },
  {
    title: 'Đăng nhập tài khoản trên ứng dụng',
    description:
      'Tải ứng dụng HiiLu để có thể cài đặt và đồng bộ hoá thẻ của bạn trên ứng dụng.',
    icon: 'phone_android',
  },
];

export function GuideSection() {
  return (
    <section id="guide" className="w-full bg-white py-10 sm:py-12">
      <div className="container-default">
        <div className="mx-auto max-w-3xl text-center">
          <p className="text-3xl font-semibold uppercase text-[#455A6B] sm:text-4xl md:text-5xl lg:text-[56px]">
            Hướng dẫn sử dụng
          </p>
          <p className="mt-2 text-base leading-relaxed text-[#4a4a4a] sm:text-lg">
            Việc sử dụng thẻ cá nhân thông minh HiiLu vô cùng đơn giản. Chỉ với vài thao tác cơ bản, bạn đã có thể nhanh chóng chia sẻ thông tin của mình một cách hiện đại và tiện lợi. Hãy cùng xem các bước hướng dẫn dưới đây để bắt đầu trải nghiệm ngay nhé!
          </p>
        </div>

        <div className="mt-8 space-y-4 sm:mt-12 sm:space-y-5">
          {steps.map((step, index) => (
            <article
              key={step.title}
              className="hover-card flex flex-col items-start gap-4 rounded-[24px] border border-white/70 bg-white p-5 shadow-[0_20px_60px_rgba(15,23,42,0.06)] sm:flex-row sm:items-center sm:gap-5 sm:rounded-[28px] sm:px-5 sm:py-5 md:px-8"
            >
              <div
                className="flex h-14 w-14 shrink-0 items-center justify-center rounded-2xl sm:h-16 sm:w-16"
                style={{ backgroundColor: '#FFB3B3' }}
              >
                <span className="material-icons text-2xl text-white sm:text-3xl">
                  {step.icon}
                </span>
              </div>
              <div className="space-y-1 flex-1">
                <p className="text-[10px] font-semibold uppercase tracking-[0.3em] text-[#8a8a8a] sm:text-xs">
                  {`Bước ${index + 1}`}
                </p>
                <h3 className="text-lg font-semibold text-[#1a1a1a] sm:text-xl">
                  {step.title}
                </h3>
                <p className="text-sm leading-relaxed text-[#5a5a5a] sm:text-base">
                  {step.description}
                </p>
              </div>
            </article>
          ))}
        </div>
      </div>
    </section>
  );
}
