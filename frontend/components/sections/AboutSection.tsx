import Image from "next/image";

const aboutBlocks = [
  {
    title: "Tầm nhìn",
    description:
      "Trở thành công cụ kết nối đáng tin cậy và hiện đại nhất, giúp mọi người rút ngắn khoảng cách - từ công nghệ đến cảm xúc. Thay thế danh thiếp giấy bằng thẻ thông minh gọn nhẹ và tiện lợi.",
    image: "/assets/web/image4.png",
    reverse: true,
    chips: ["Tin cậy", "Hiện đại", "Cảm hứng"],
    imageWidth: 520,
    imageHeight: 408,
    padding: false
  },
  {
    title: "Điểm nổi bật",
    description:
      "Ứng dụng công nghệ mới giúp chia sẻ thông tin chỉ trong một chạm. Thiết kế đơn giản, hiện đại, bảo mật cao. Mọi dữ liệu đều được lưu trữ an toàn và dễ dàng cập nhật bất cứ lúc nào.",
    image: "/assets/web/image3.png",
    reverse: false,
    chips: ["Bảo mật cao", "Cập nhật tức thì"],
    imageWidth: 288,
    imageHeight: 346,
    padding: true
  }
];

export function AboutSection() {
  return (
    <section id="about" className="w-full py-12 sm:py-16 md:py-20">
      <div className="container-default">
        <div className="mx-auto mb-12 max-w-3xl text-center sm:mb-16 md:mb-20">
          <p className="text-3xl font-semibold uppercase text-[#455A6B] sm:text-4xl md:text-5xl lg:text-[56px]">
            Giới thiệu
          </p>
          <p className="mt-4 text-base leading-relaxed text-[#4a4a4a] sm:mt-6 sm:text-lg">
            Trong thế giới nơi mọi thứ đang được số hoá, HiiLu mang đến cách kết
            nối mới, chuyên nghiệp và bền vững hơn. Bạn có thể dễ dàng chia sẻ
            thông tin, lưu giữ dữ liệu và tạo ấn tượng trong từng lần chạm.
          </p>
        </div>

        <div className="space-y-16 sm:space-y-20 md:space-y-24">
          {aboutBlocks.map((block, index) => {
            const textOrder = block.reverse
              ? "order-2 md:order-2"
              : "order-2 md:order-1";
            const imageOrder = block.reverse
              ? "order-1 md:order-1"
              : "order-1 md:order-2";

            return (
              <div
                key={block.title}
                className="grid gap-8 md:grid-cols-2 md:items-center md:gap-12 lg:gap-16"
              >
                <div className={`${textOrder} flex flex-col justify-center`}>
                  <div className="space-y-5 sm:space-y-6">
                    <h3 className="text-2xl font-semibold text-[#1a1a1a] sm:text-3xl">
                      {block.title}
                    </h3>
                    <p className="text-base leading-relaxed text-[#4a4a4a] sm:text-lg">
                      {block.description}
                    </p>
                    <div className="flex flex-wrap gap-3">
                      {block.chips.map((chip) => (
                        <span
                          key={chip}
                          className="rounded-full border border-[#e3e9ff] bg-white px-4 py-1.5 text-sm font-medium text-[#5a5a5a]"
                        >
                          {chip}
                        </span>
                      ))}
                    </div>
                  </div>
                </div>

                <div
                  className={`${imageOrder} flex items-center justify-center`}
                >
                  <div className="relative w-full max-w-md overflow-hidden rounded-[28px] sm:max-w-lg md:max-w-xl">
                    <div
                      className="relative w-full"
                      style={{
                        aspectRatio: `${block.imageWidth} / ${block.imageHeight}`,
                        maxHeight: "500px"
                      }}
                    >
                      <Image
                        src={block.image}
                        alt={block.title}
                        width={block.imageWidth}
                        height={block.imageHeight}
                        className="h-full w-full object-contain"
                        priority={index === 0}
                      />
                    </div>
                  </div>
                </div>
              </div>
            );
          })}
        </div>
      </div>
    </section>
  );
}
