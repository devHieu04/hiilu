//
//  LandingPageView.swift
//  Hiilu
//
//  Created on 30/11/25.
//

import SwiftUI

struct LandingPageView: View {
    @StateObject private var authManager = AuthManager.shared
    @State private var currentFeatureIndex = 0
    @State private var showLogin = false
    @State private var showRegister = false

    let highlightFeatures = [
        HighlightFeature(
            title: "Chạm để chia sẻ",
            description: "Chia sẻ thông tin liên hệ chỉ với một lần chạm.",
            icon: "antenna",
            bgColor: Color(red: 0.84, green: 0.97, blue: 0.94)
        ),
        HighlightFeature(
            title: "Kết nối nhanh",
            description: "Kết nối bạn bè, đối tác trong tích tắc.",
            icon: "link",
            bgColor: Color(red: 0.90, green: 0.90, blue: 1.0)
        ),
        HighlightFeature(
            title: "Xây dựng thương hiệu",
            description: "Một danh thiếp thông minh, ấn tượng chuyên nghiệp.",
            icon: "brand (2)",
            bgColor: Color(red: 0.99, green: 0.91, blue: 0.95)
        )
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Hero Section
                HeroSectionView(showLogin: $showLogin, showRegister: $showRegister)

                // Highlight Features
                HighlightFeaturesView(
                    features: highlightFeatures,
                    currentIndex: $currentFeatureIndex
                )
                .padding(.top, -60)

                // About Section
                AboutSectionView()
                    .padding(.top, 40)

                // Features Section
                FeaturesSectionView()
                    .padding(.top, 40)

                // Contact Section
                ContactSectionView()
                    .padding(.top, 40)
                    .padding(.bottom, 40)
            }
        }
        .background(
            LinearGradient(
                colors: [
                    Color(red: 0.96, green: 0.96, blue: 1.0),
                    Color(red: 0.93, green: 0.95, blue: 1.0),
                    Color.white
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .sheet(isPresented: $showLogin) {
            LoginView()
        }
        .sheet(isPresented: $showRegister) {
            RegisterView()
        }
    }
}

struct HighlightFeature {
    let title: String
    let description: String
    let icon: String
    let bgColor: Color
}

struct HeroSectionView: View {
    @Binding var showLogin: Bool
    @Binding var showRegister: Bool

    var body: some View {
        VStack(spacing: 24) {
            // Logo and Title
            VStack(spacing: 8) {
                if let logoImage = UIImage(named: "Group 4") {
                    Image(uiImage: logoImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 92, height: 32)
                } else {
                    Text("HiiLu")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(Color(red: 0.43, green: 0.76, blue: 0.96))
                }

                Text("HiiLu")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.gray)
            }
            .padding(.top, 20)

            // Hero Content
            VStack(alignment: .leading, spacing: 16) {
                Text("HIILU PLATFORM")
                    .font(.system(size: 10, weight: .semibold))
                    .tracking(3.5)
                    .foregroundColor(Color(red: 0.35, green: 0.42, blue: 0.62))

                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 0) {
                        Text("Kết nối ")
                            .font(.system(size: 32, weight: .semibold))
                            .foregroundColor(.black)
                        Text("một chạm")
                            .font(.system(size: 32, weight: .semibold))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.29, green: 0.84, blue: 0.76),
                                        Color(red: 0.43, green: 0.76, blue: 0.96)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                    }

                    HStack(spacing: 0) {
                        Text("chia sẻ ")
                            .font(.system(size: 32, weight: .semibold))
                            .foregroundColor(.black)
                        Text("không giới hạn")
                            .font(.system(size: 32, weight: .semibold))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.29, green: 0.84, blue: 0.76),
                                        Color(red: 0.43, green: 0.76, blue: 0.96)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                    }
                }

                Text("Nền tảng tạo và chia sẻ thẻ cá nhân thông minh tại Việt Nam. Chỉ vài thao tác là bạn đã có thể truyền tải đầy đủ thông tin của mình một cách hiện đại và bảo mật.")
                    .font(.system(size: 16))
                    .foregroundColor(Color(red: 0.29, green: 0.29, blue: 0.29))
                    .lineSpacing(4)

                // Tags
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        TagView(text: "Freelancer")
                        TagView(text: "Doanh nhân")
                        TagView(text: "Sinh viên")
                        TagView(text: "Doanh nghiệp")
                    }
                }

                // CTA Buttons
                HStack(spacing: 12) {
                    Button(action: {
                        showLogin = true
                    }) {
                        Text("Đăng nhập")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color(red: 0.05, green: 0.56, blue: 0.63))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.white)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(red: 0.43, green: 0.76, blue: 0.96), lineWidth: 1)
                            )
                    }

                    Button(action: {
                        showRegister = true
                    }) {
                        Text("Đăng ký")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.29, green: 0.84, blue: 0.76),
                                        Color(red: 0.43, green: 0.76, blue: 0.96)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(12)
                            .shadow(color: Color(red: 0.29, green: 0.84, blue: 0.76).opacity(0.4), radius: 12, x: 0, y: 6)
                    }
                }
            }
            .padding(.horizontal, 20)

            // Hero Image
            if let heroImage = UIImage(named: "Group 69") {
                Image(uiImage: heroImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 300)
                    .padding(.top, 20)
            } else {
                // Fallback if image not found
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 300, height: 280)
                    .padding(.top, 20)
            }
        }
        .padding(.vertical, 24)
        .background(
            LinearGradient(
                colors: [
                    Color(red: 0.996, green: 0.953, blue: 1.0),
                    Color(red: 0.945, green: 0.910, blue: 1.0),
                    Color(red: 0.898, green: 0.949, blue: 1.0)
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
    }
}

struct TagView: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.system(size: 10, weight: .semibold))
            .foregroundColor(.black)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.white.opacity(0.7))
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(0.8), lineWidth: 1)
            )
    }
}

struct HighlightFeaturesView: View {
    let features: [HighlightFeature]
    @Binding var currentIndex: Int

    var body: some View {
        VStack(spacing: 16) {
            TabView(selection: $currentIndex) {
                ForEach(0..<features.count, id: \.self) { index in
                    FeatureCardView(feature: features[index])
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 280)

            // Page indicators
            HStack(spacing: 8) {
                ForEach(0..<features.count, id: \.self) { index in
                    Circle()
                        .fill(index == currentIndex ? Color(red: 0.55, green: 0.36, blue: 0.96) : Color.gray.opacity(0.3))
                        .frame(width: index == currentIndex ? 32 : 8, height: 8)
                        .animation(.spring(), value: currentIndex)
                }
            }
        }
        .padding(.horizontal, 16)
    }
}

struct FeatureCardView: View {
    let feature: HighlightFeature

    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(feature.bgColor)
                    .frame(width: 64, height: 64)

                if let image = UIImage(named: feature.icon) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.gray)
                }
            }

            Text(feature.title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.black)

            Text(feature.description)
                .font(.system(size: 12))
                .foregroundColor(Color(red: 0.35, green: 0.35, blue: 0.35))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 32)
        .padding(.horizontal, 24)
        .background(Color.white)
        .cornerRadius(24)
        .shadow(color: Color(red: 0.47, green: 0.49, blue: 1.0).opacity(0.15), radius: 30, x: 0, y: 15)
    }
}

struct AboutSectionView: View {
    var body: some View {
        VStack(spacing: 32) {
            VStack(spacing: 12) {
                Text("GIỚI THIỆU")
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundColor(Color(red: 0.27, green: 0.35, blue: 0.42))

                Text("Trong thế giới nơi mọi thứ đang được số hoá, HiiLu mang đến cách kết nối mới, chuyên nghiệp và bền vững hơn. Bạn có thể dễ dàng chia sẻ thông tin, lưu giữ dữ liệu và tạo ấn tượng trong từng lần chạm.")
                    .font(.system(size: 14))
                    .foregroundColor(Color(red: 0.29, green: 0.29, blue: 0.29))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 20)

            // About blocks
            VStack(spacing: 40) {
                AboutBlockView(
                    title: "Tầm nhìn",
                    description: "Trở thành công cụ kết nối đáng tin cậy và hiện đại nhất, giúp mọi người rút ngắn khoảng cách - từ công nghệ đến cảm xúc. Thay thế danh thiếp giấy bằng thẻ thông minh gọn nhẹ và tiện lợi.",
                    image: "image4",
                    chips: ["Tin cậy", "Hiện đại", "Cảm hứng"]
                )

                AboutBlockView(
                    title: "Điểm nổi bật",
                    description: "Ứng dụng công nghệ mới giúp chia sẻ thông tin chỉ trong một chạm. Thiết kế đơn giản, hiện đại, bảo mật cao. Mọi dữ liệu đều được lưu trữ an toàn và dễ dàng cập nhật bất cứ lúc nào.",
                    image: "image3",
                    chips: ["Bảo mật cao", "Cập nhật tức thì"]
                )
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 40)
        .background(Color.white)
    }
}

struct AboutBlockView: View {
    let title: String
    let description: String
    let image: String
    let chips: [String]

    var body: some View {
        VStack(spacing: 20) {
            if let aboutImage = UIImage(named: image) {
                Image(uiImage: aboutImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 300)
                    .cornerRadius(28)
            } else {
                RoundedRectangle(cornerRadius: 28)
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 300)
            }

            VStack(alignment: .leading, spacing: 16) {
                Text(title)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.black)

                Text(description)
                    .font(.system(size: 14))
                    .foregroundColor(Color(red: 0.29, green: 0.29, blue: 0.29))
                    .lineSpacing(4)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(chips, id: \.self) { chip in
                            Text(chip)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color(red: 0.35, green: 0.35, blue: 0.35))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 6)
                                .background(Color.white)
                                .cornerRadius(20)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color(red: 0.89, green: 0.91, blue: 1.0), lineWidth: 1)
                                )
                        }
                    }
                }
            }
        }
    }
}

struct FeaturesSectionView: View {
    let features = [
        FeatureData(
            title: "Tùy chỉnh giao diện",
            description: "Thoả sức sáng tạo với nhiều lựa chọn màu sắc, phong cách để danh thiếp của bạn trở nên chuyên nghiệp hơn bao giờ hết.",
            icon: "color-palette",
            accent: Color(red: 0.875, green: 0.961, blue: 0.925)
        ),
        FeatureData(
            title: "Cập nhật thông tin",
            description: "Bạn có thể chỉnh sửa hoặc bổ sung thông tin cá nhân chỉ trong vài thao tác. Tất cả thay đổi sẽ được đồng bộ ngay trên danh thiếp của bạn.",
            icon: "user-profile-01",
            accent: Color(red: 0.910, green: 0.941, blue: 1.0)
        ),
        FeatureData(
            title: "Thẻ thông minh",
            description: "Chia sẻ thông tin liên hệ chỉ bằng một lần chạm hoặc một lần quét – không cần app, không cần kết nối mạng.",
            icon: "id-card",
            accent: Color(red: 0.992, green: 0.922, blue: 0.953)
        ),
        FeatureData(
            title: "Gửi lời nhắn",
            description: "Người khác có thể để lại thông tin và lời nhắn cho bạn sau khi chạm thẻ. Mọi tương tác đều được lưu lại để bạn kết nối và phản hồi.",
            icon: "chat",
            accent: Color(red: 1.0, green: 0.961, blue: 0.875)
        ),
        FeatureData(
            title: "Liên kết bio",
            description: "Tổng hợp tất cả link quan trọng của bạn: Facebook, Instagram, Zalo, LinkedIn, portfolio... trong một trang duy nhất.",
            icon: "link-angled",
            accent: Color(red: 0.914, green: 0.925, blue: 1.0)
        ),
        FeatureData(
            title: "Hỗ trợ tận tâm 24/7",
            description: "Đội ngũ HiiLu luôn đồng hành cùng bạn, sẵn sàng hướng dẫn và giải quyết mọi khó khăn trong quá trình sử dụng thẻ.",
            icon: "personalized-support",
            accent: Color(red: 0.902, green: 0.965, blue: 1.0)
        )
    ]

    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 12) {
                Text("TÍNH NĂNG CỦA HIILU")
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundColor(Color(red: 0.27, green: 0.35, blue: 0.42))

                Text("Khám phá những tính năng mạnh mẽ giúp bạn tạo ra danh thiếp số chuyên nghiệp, kết nối hiệu quả và quản lý thông tin một cách thông minh.")
                    .font(.system(size: 14))
                    .foregroundColor(Color(red: 0.29, green: 0.29, blue: 0.29))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 20)

            // Feature cards
            VStack(spacing: 16) {
                ForEach(features, id: \.title) { feature in
                    FeatureItemView(
                        icon: feature.icon,
                        title: feature.title,
                        description: feature.description,
                        accent: feature.accent
                    )
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 40)
        .background(
            LinearGradient(
                colors: [
                    Color(red: 0.96, green: 0.96, blue: 1.0),
                    Color.white
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
}

struct FeatureData {
    let title: String
    let description: String
    let icon: String
    let accent: Color
}

struct FeatureItemView: View {
    let icon: String
    let title: String
    let description: String
    let accent: Color

    var body: some View {
        HStack(spacing: 16) {
            if let featureImage = UIImage(named: icon) {
                Image(uiImage: featureImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 48, height: 48)
                    .padding(12)
                    .background(accent)
                    .cornerRadius(12)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 48, height: 48)
                    .padding(12)
                    .background(accent)
                    .cornerRadius(12)
                    .foregroundColor(.gray)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)

                Text(description)
                    .font(.system(size: 12))
                    .foregroundColor(Color(red: 0.35, green: 0.35, blue: 0.35))
                    .lineSpacing(2)
            }

            Spacer()
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

struct ContactSectionView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Liên hệ HiiLu")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white)

            Text("Đội ngũ HiiLu luôn đồng hành cùng bạn, sẵn sàng hướng dẫn và giải đáp mọi thắc mắc trong suốt quá trình sử dụng sản phẩm.")
                .font(.system(size: 12))
                .foregroundColor(.white.opacity(0.9))
                .multilineTextAlignment(.center)
                .lineSpacing(4)

            VStack(spacing: 12) {
                ContactItemView(
                    icon: "phone",
                    label: "Hotline",
                    value: "0358605833"
                )

                ContactItemView(
                    icon: "mail",
                    label: "Email",
                    value: "contact@hiilu.pics"
                )
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                colors: [
                    Color(red: 0.04, green: 0.36, blue: 0.88),
                    Color(red: 0.07, green: 0.51, blue: 1.0)
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
    }
}

struct ContactItemView: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon == "phone" ? "phone.fill" : "envelope.fill")
                .font(.system(size: 20))
                .foregroundColor(.white)
                .frame(width: 40, height: 40)
                .background(Color.white.opacity(0.2))
                .cornerRadius(10)

            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.8))

                Text(value)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
            }

            Spacer()
        }
        .padding(16)
        .background(Color.white.opacity(0.1))
        .cornerRadius(12)
    }
}

// MARK: - Login View
struct LoginView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var authManager = AuthManager.shared
    @State private var email = ""
    @State private var password = ""
    @State private var showPassword = false
    @State private var errorMessage = ""
    @State private var isLoading = false
    @State private var showRegister = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Logo
                    VStack(spacing: 8) {
                if let logoImage = UIImage(named: "Group 4") {
                    Image(uiImage: logoImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 92, height: 32)
                } else {
                    Text("HiiLu")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(Color(red: 0.43, green: 0.76, blue: 0.96))
                }
                        Text("HiiLu")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 40)

                    // Title
                    VStack(spacing: 8) {
                        Text("Đăng nhập")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.black)
                        Text("Chào mừng bạn trở lại!")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                    .padding(.bottom, 8)

                    // Error message
                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .font(.system(size: 14))
                            .foregroundColor(.red)
                            .padding(.horizontal)
                            .multilineTextAlignment(.center)
                    }

                    // Form
                    VStack(spacing: 16) {
                        // Email field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Email")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.black)
                            TextField("Nhập email của bạn", text: $email)
                                .textFieldStyle(CustomTextFieldStyle())
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .autocorrectionDisabled()
                        }

                        // Password field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Mật khẩu")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.black)
                            HStack {
                                if showPassword {
                                    TextField("Nhập mật khẩu", text: $password)
                                        .textFieldStyle(CustomTextFieldStyle())
                                } else {
                                    SecureField("Nhập mật khẩu", text: $password)
                                        .textFieldStyle(CustomTextFieldStyle())
                                }
                                Button(action: { showPassword.toggle() }) {
                                    Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                        .foregroundColor(.gray)
                                }
                            }
                        }

                        // Login button
                        Button(action: handleLogin) {
                            HStack {
                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                } else {
                                    Text("Đăng nhập")
                                        .font(.system(size: 16, weight: .semibold))
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.29, green: 0.84, blue: 0.76),
                                        Color(red: 0.43, green: 0.76, blue: 0.96)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .shadow(color: Color(red: 0.29, green: 0.84, blue: 0.76).opacity(0.4), radius: 12, x: 0, y: 6)
                        }
                        .disabled(isLoading || email.isEmpty || password.isEmpty)
                        .opacity((isLoading || email.isEmpty || password.isEmpty) ? 0.6 : 1.0)
                    }
                    .padding(.horizontal, 24)

                    // Register link
                    HStack {
                        Text("Chưa có tài khoản?")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        Button(action: {
                            dismiss()
                            showRegister = true
                        }) {
                            Text("Đăng ký ngay")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(Color(red: 0.43, green: 0.76, blue: 0.96))
                        }
                    }
                    .padding(.top, 8)
                }
                .padding(.vertical, 32)
            }
            .background(
                LinearGradient(
                    colors: [
                        Color(red: 0.996, green: 0.953, blue: 1.0),
                        Color(red: 0.945, green: 0.910, blue: 1.0),
                        Color(red: 0.898, green: 0.949, blue: 1.0)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .navigationTitle("Đăng nhập")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Đóng") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showRegister) {
                RegisterView()
            }
        }
    }

    private func handleLogin() {
        print("🔑 [LoginView] Login button tapped")
        print("   - Email: \(email)")
        print("   - Password length: \(password.count)")

        errorMessage = ""
        isLoading = true

        Task {
            do {
                print("🚀 [LoginView] Calling authManager.login...")
                try await authManager.login(email: email, password: password)

                await MainActor.run {
                    isLoading = false
                    print("✅ [LoginView] Login successful")
                    print("   - User authenticated: \(authManager.isAuthenticated)")
                    print("   - Navigating to Home...")
                    dismiss()
                    // ContentView will automatically show HomeView because authManager.isAuthenticated is now true
                }
            } catch {
                print("❌ [LoginView] Login error caught: \(error.localizedDescription)")
                await MainActor.run {
                    isLoading = false
                    if let apiError = error as? APIError {
                        errorMessage = apiError.localizedDescription
                        print("   - Error message: \(errorMessage)")
                    } else {
                        errorMessage = "Đăng nhập thất bại. Vui lòng thử lại."
                        print("   - Generic error message shown")
                    }
                }
            }
        }
    }
}

// MARK: - Register View
struct RegisterView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var authManager = AuthManager.shared
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showPassword = false
    @State private var showConfirmPassword = false
    @State private var errorMessage = ""
    @State private var isLoading = false
    @State private var showLogin = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Logo
                    VStack(spacing: 8) {
                if let logoImage = UIImage(named: "Group 4") {
                    Image(uiImage: logoImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 92, height: 32)
                } else {
                    Text("HiiLu")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(Color(red: 0.43, green: 0.76, blue: 0.96))
                }
                        Text("HiiLu")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 40)

                    // Title
                    VStack(spacing: 8) {
                        Text("Đăng ký")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.black)
                        Text("Tạo tài khoản mới để bắt đầu")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                    .padding(.bottom, 8)

                    // Error message
                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .font(.system(size: 14))
                            .foregroundColor(.red)
                            .padding(.horizontal)
                            .multilineTextAlignment(.center)
                    }

                    // Form
                    VStack(spacing: 16) {
                        // Name field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Họ và tên")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.black)
                            TextField("Nhập họ và tên", text: $name)
                                .textFieldStyle(CustomTextFieldStyle())
                        }

                        // Email field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Email")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.black)
                            TextField("Nhập email của bạn", text: $email)
                                .textFieldStyle(CustomTextFieldStyle())
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .autocorrectionDisabled()
                        }

                        // Password field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Mật khẩu")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.black)
                            HStack {
                                if showPassword {
                                    TextField("Nhập mật khẩu", text: $password)
                                        .textFieldStyle(CustomTextFieldStyle())
                                } else {
                                    SecureField("Nhập mật khẩu", text: $password)
                                        .textFieldStyle(CustomTextFieldStyle())
                                }
                                Button(action: { showPassword.toggle() }) {
                                    Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                        .foregroundColor(.gray)
                                }
                            }
                        }

                        // Confirm password field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Xác nhận mật khẩu")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.black)
                            HStack {
                                if showConfirmPassword {
                                    TextField("Nhập lại mật khẩu", text: $confirmPassword)
                                        .textFieldStyle(CustomTextFieldStyle())
                                } else {
                                    SecureField("Nhập lại mật khẩu", text: $confirmPassword)
                                        .textFieldStyle(CustomTextFieldStyle())
                                }
                                Button(action: { showConfirmPassword.toggle() }) {
                                    Image(systemName: showConfirmPassword ? "eye.slash.fill" : "eye.fill")
                                        .foregroundColor(.gray)
                                }
                            }
                        }

                        // Register button
                        Button(action: handleRegister) {
                            HStack {
                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                } else {
                                    Text("Đăng ký")
                                        .font(.system(size: 16, weight: .semibold))
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.29, green: 0.84, blue: 0.76),
                                        Color(red: 0.43, green: 0.76, blue: 0.96)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .shadow(color: Color(red: 0.29, green: 0.84, blue: 0.76).opacity(0.4), radius: 12, x: 0, y: 6)
                        }
                        .disabled(isLoading || !isFormValid)
                        .opacity((isLoading || !isFormValid) ? 0.6 : 1.0)
                    }
                    .padding(.horizontal, 24)

                    // Login link
                    HStack {
                        Text("Đã có tài khoản?")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        Button(action: {
                            dismiss()
                            showLogin = true
                        }) {
                            Text("Đăng nhập ngay")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(Color(red: 0.43, green: 0.76, blue: 0.96))
                        }
                    }
                    .padding(.top, 8)
                }
                .padding(.vertical, 32)
            }
            .background(
                LinearGradient(
                    colors: [
                        Color(red: 0.996, green: 0.953, blue: 1.0),
                        Color(red: 0.945, green: 0.910, blue: 1.0),
                        Color(red: 0.898, green: 0.949, blue: 1.0)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .navigationTitle("Đăng ký")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Đóng") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showLogin) {
                LoginView()
            }
        }
    }

    private var isFormValid: Bool {
        return !name.isEmpty &&
               name.count >= 2 &&
               !email.isEmpty &&
               !password.isEmpty &&
               password.count >= 6 &&
               password == confirmPassword
    }

    private func handleRegister() {
        print("📝 [RegisterView] Register button tapped")
        print("   - Name: \(name)")
        print("   - Email: \(email)")
        print("   - Password length: \(password.count)")

        errorMessage = ""

        // Validation
        if name.count < 2 {
            errorMessage = "Tên phải có ít nhất 2 ký tự"
            return
        }

        if password.count < 6 {
            errorMessage = "Mật khẩu phải có ít nhất 6 ký tự"
            return
        }

        if password != confirmPassword {
            errorMessage = "Mật khẩu xác nhận không khớp"
            return
        }

        isLoading = true

        Task {
            do {
                print("🚀 [RegisterView] Calling authManager.register...")
                try await authManager.register(email: email, name: name, password: password)

                await MainActor.run {
                    isLoading = false
                    print("✅ [RegisterView] Register successful")
                    print("   - User authenticated: \(authManager.isAuthenticated)")
                    print("   - Navigating to Home...")
                    dismiss()
                    // ContentView will automatically show HomeView because authManager.isAuthenticated is now true
                }
            } catch {
                print("❌ [RegisterView] Register error caught: \(error.localizedDescription)")
                await MainActor.run {
                    isLoading = false
                    if let apiError = error as? APIError {
                        let errorDesc = apiError.localizedDescription
                        if errorDesc.contains("already registered") || errorDesc.contains("409") {
                            errorMessage = "Email này đã được đăng ký. Vui lòng sử dụng email khác."
                        } else {
                            errorMessage = errorDesc
                        }
                    } else {
                        errorMessage = "Đăng ký thất bại. Vui lòng thử lại."
                    }
                    print("   - Error message: \(errorMessage)")
                }
            }
        }
    }
}

// MARK: - Custom Text Field Style
struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(14)
            .background(Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
    }
}

#Preview {
    LandingPageView()
}
