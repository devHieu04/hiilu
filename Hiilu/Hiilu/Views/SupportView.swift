//
//  SupportView.swift
//  Hiilu
//
//  Created on 30/11/25.
//

import SwiftUI

struct SupportView: View {
    @State private var searchText = ""

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Tìm kiếm câu hỏi...", text: $searchText)
                            .font(.system(size: 16))
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                    .padding(.horizontal, 20)
                    .padding(.top, 20)

                    // Quick Help Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Trợ giúp nhanh")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.horizontal, 20)

                        VStack(spacing: 12) {
                            SupportMenuItem(
                                icon: "questionmark.circle.fill",
                                title: "Câu hỏi thường gặp",
                                description: "Tìm câu trả lời cho các câu hỏi phổ biến",
                                color: Color(red: 0.43, green: 0.76, blue: 0.96)
                            ) {
                                print("❓ [SupportView] FAQ tapped")
                            }

                            SupportMenuItem(
                                icon: "book.fill",
                                title: "Hướng dẫn sử dụng",
                                description: "Tìm hiểu cách sử dụng ứng dụng",
                                color: Color(red: 0.29, green: 0.84, blue: 0.76)
                            ) {
                                print("📖 [SupportView] Guide tapped")
                            }

                            SupportMenuItem(
                                icon: "message.fill",
                                title: "Liên hệ hỗ trợ",
                                description: "Chat với đội ngũ hỗ trợ của chúng tôi",
                                color: Color(red: 0.96, green: 0.65, blue: 0.14)
                            ) {
                                print("💬 [SupportView] Contact support tapped")
                            }

                            SupportMenuItem(
                                icon: "exclamationmark.triangle.fill",
                                title: "Báo cáo lỗi",
                                description: "Gửi phản hồi về lỗi hoặc vấn đề gặp phải",
                                color: Color(red: 0.96, green: 0.26, blue: 0.21)
                            ) {
                                print("🐛 [SupportView] Report bug tapped")
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.top, 10)

                    // Contact Information
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Thông tin liên hệ")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.horizontal, 20)

                        VStack(spacing: 12) {
                            ContactInfoItem(
                                icon: "envelope.fill",
                                title: "Email",
                                value: "support@hiilu.com",
                                color: Color(red: 0.43, green: 0.76, blue: 0.96)
                            )

                            ContactInfoItem(
                                icon: "phone.fill",
                                title: "Hotline",
                                value: "1900 1234",
                                color: Color(red: 0.29, green: 0.84, blue: 0.76)
                            )

                            ContactInfoItem(
                                icon: "clock.fill",
                                title: "Giờ làm việc",
                                value: "Thứ 2 - Thứ 6: 9:00 - 18:00",
                                color: Color(red: 0.96, green: 0.65, blue: 0.14)
                            )
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.top, 10)

                    // App Version
                    VStack(spacing: 4) {
                        Text("Phiên bản 1.0.0")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                        Text("© 2025 Hiilu. All rights reserved.")
                            .font(.system(size: 10))
                            .foregroundColor(.gray.opacity(0.7))
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                }
            }
            .background(
                LinearGradient(
                    colors: [
                        Color(red: 0.996, green: 0.953, blue: 1.0),
                        Color(red: 0.945, green: 0.910, blue: 1.0),
                        Color.white
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .navigationTitle("Hỗ trợ")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct SupportMenuItem: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(color)
                    .frame(width: 50, height: 50)
                    .background(color.opacity(0.1))
                    .cornerRadius(12)

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)

                    Text(description)
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                        .lineLimit(2)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        }
    }
}

struct ContactInfoItem: View {
    let icon: String
    let title: String
    let value: String
    let color: Color

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
                .frame(width: 40, height: 40)
                .background(color.opacity(0.1))
                .cornerRadius(10)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)

                Text(value)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.black)
            }

            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    SupportView()
}
