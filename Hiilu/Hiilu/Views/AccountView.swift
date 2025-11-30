//
//  AccountView.swift
//  Hiilu
//
//  Created on 30/11/25.
//

import SwiftUI

struct AccountView: View {
    @StateObject private var authManager = AuthManager.shared
    @State private var showLogoutAlert = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Profile Header
                    VStack(spacing: 16) {
                        // Avatar
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.43, green: 0.76, blue: 0.96),
                                        Color(red: 0.29, green: 0.84, blue: 0.76)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 100, height: 100)
                            .overlay(
                                Text(getInitials(authManager.user?.name ?? ""))
                                    .font(.system(size: 36, weight: .bold))
                                    .foregroundColor(.white)
                            )
                            .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)

                        // User Info
                        VStack(spacing: 4) {
                            Text(authManager.user?.name ?? "")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.black)

                            Text(authManager.user?.email ?? "")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.top, 40)
                    .padding(.bottom, 20)

                    // Account Options
                    VStack(spacing: 12) {
                        // Profile Settings
                        NavigationLink(destination: EditProfileView()) {
                            AccountMenuItem(
                                icon: "person.circle.fill",
                                title: "Thông tin cá nhân",
                                color: Color(red: 0.43, green: 0.76, blue: 0.96),
                                action: {}
                            )
                        }

                        // Change Password
                        NavigationLink(destination: ChangePasswordView()) {
                            AccountMenuItem(
                                icon: "lock.fill",
                                title: "Đổi mật khẩu",
                                color: Color(red: 0.29, green: 0.84, blue: 0.76),
                                action: {}
                            )
                        }
                    }
                    .padding(.horizontal, 20)

                    // Logout Button
                    Button(action: {
                        showLogoutAlert = true
                    }) {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .font(.system(size: 16))
                            Text("Đăng xuất")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.red.opacity(0.1))
                        .foregroundColor(.red)
                        .cornerRadius(12)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
                .padding(.bottom, 40)
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
            .navigationTitle("Tài khoản")
            .navigationBarTitleDisplayMode(.large)
        }
        .alert("Đăng xuất", isPresented: $showLogoutAlert) {
            Button("Hủy", role: .cancel) {}
            Button("Đăng xuất", role: .destructive) {
                authManager.logout()
                print("🚪 [AccountView] User logged out")
            }
        } message: {
            Text("Bạn có chắc chắn muốn đăng xuất?")
        }
    }

    private func getInitials(_ name: String) -> String {
        return name
            .split(separator: " ")
            .compactMap { $0.first }
            .prefix(2)
            .map { String($0) }
            .joined()
            .uppercased()
    }
}

struct AccountMenuItem: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
                .frame(width: 40, height: 40)
                .background(color.opacity(0.1))
                .cornerRadius(10)

            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.black)

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 14))
                .foregroundColor(.gray)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    AccountView()
}
