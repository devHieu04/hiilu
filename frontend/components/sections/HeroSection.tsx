import Image from "next/image";

export function HeroSection() {
  return (
    <section id="hero" className="w-full">
      <div className="relative overflow-hidden px-4 py-6 sm:px-6 sm:py-8 md:px-12">
        <div className="grid min-h-[500px] gap-8 sm:min-h-[600px] sm:gap-10 md:grid-cols-2 md:items-center md:min-h-[640px]">
          <div className="order-2 space-y-6 sm:space-y-8 md:order-1">
            <p className="text-[10px] font-semibold uppercase tracking-[0.35em] text-[#5a6a9f] sm:text-xs">
              HIILU PLATFORM
            </p>
            <h1 className="text-3xl font-semibold leading-[1.15] text-[#1a1a1a] sm:text-4xl md:text-[56px]">
              Kết nối{" "}
              <span className="bg-gradient-to-r from-[#00BFA6] to-[#6ec3f4] bg-clip-text text-transparent">
                một chạm
              </span>
              <br />
              chia sẻ{" "}
              <span className="bg-gradient-to-r from-[#00BFA6] to-[#6ec3f4] bg-clip-text text-transparent">
                không giới hạn
              </span>
            </h1>
            <p className="text-base leading-relaxed text-[#4a4a4a] sm:text-lg md:text-xl">
              Nền tảng tạo và chia sẻ thẻ cá nhân thông minh tại Việt Nam. Chỉ
              vài thao tác là bạn đã có thể truyền tải đầy đủ thông tin của mình
              một cách hiện đại và bảo mật.
            </p>
            <div className="flex flex-wrap gap-2 sm:gap-3">
              {["Freelancer", "Doanh nhân", "Sinh viên", "Doanh nghiệp"].map(
                (tag) => (
                  <span
                    key={tag}
                    className="rounded-full border border-white/80 bg-white/70 px-3 py-1.5 text-[10px] font-semibold shadow-inner shadow-white sm:px-4 sm:py-2 sm:text-xs"
                  >
                    {tag}
                  </span>
                )
              )}
            </div>
          </div>

          <div className="order-1 flex h-full items-center justify-center md:order-2">
            <div className="relative w-full max-w-[300px] sm:max-w-[400px] md:max-w-[460px]">
              <div className="absolute inset-0 -z-10 rounded-[40px] bg-white/60 blur-2xl card-surface" />
              <Image
                src="/assets/web/Group 69.png"
                alt="Minh họa thẻ HiiLu"
                width={460}
                height={420}
                className="h-full w-full object-contain animate-floating-slow"
                priority
              />
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
