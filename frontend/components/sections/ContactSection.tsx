const contactItems = [
  {
    label: 'Hotline',
    value: '0358605833',
    icon: 'phone',
  },
  {
    label: 'Email',
    value: 'contact@hiilu.pics',
    icon: 'email',
  },
];

export function ContactSection() {
  return (
    <section
      id="contact"
      className="w-full bg-gradient-to-r from-[#0a5de1] to-[#1282ff] py-6 text-white sm:py-8"
    >
      <div className="mx-auto w-full max-w-7xl px-6 sm:px-8">
        <div className="mx-auto flex max-w-4xl flex-col items-center gap-2 text-center sm:gap-3">
          <h2 className="text-xl font-semibold text-white sm:text-2xl md:text-3xl">
            Liên hệ HiiLu
          </h2>
          <p className="text-xs leading-relaxed text-white/90 sm:text-sm">
            Đội ngũ HiiLu luôn đồng hành cùng bạn, sẵn sàng hướng dẫn và giải đáp mọi thắc
            mắc trong suốt quá trình sử dụng sản phẩm.
          </p>

          <div className="mt-2 grid w-full gap-3 sm:mt-3 sm:grid-cols-2 sm:gap-4">
            {contactItems.map((item) => (
              <article
                key={item.label}
                className="group flex items-center gap-2 rounded-[16px] bg-white/10 px-4 py-3 backdrop-blur-sm transition-all hover:bg-white/15 hover:shadow-xl sm:gap-3 sm:px-5 sm:py-4"
              >
                <div className="flex h-10 w-10 shrink-0 items-center justify-center rounded-xl bg-white/20 transition-all group-hover:scale-110 sm:h-12 sm:w-12">
                  <span className="material-icons text-xl text-white sm:text-2xl">
                    {item.icon}
                  </span>
                </div>
                <div className="min-w-0 flex-1 text-left">
                  <p className="mb-0.5 text-[10px] font-medium text-white/80 sm:text-xs">
                    {item.label}
                  </p>
                  <p className="text-sm font-semibold text-white sm:text-base">
                    {item.value}
                  </p>
                </div>
              </article>
            ))}
          </div>
        </div>
      </div>
    </section>
  );
}
