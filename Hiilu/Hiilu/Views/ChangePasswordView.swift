//
//  ChangePasswordView.swift
//  Hiilu
//
//  Created on 30/11/25.
//

import SwiftUI

struct ChangePasswordView: View {
    @Environment(\.dismiss) var dismiss

    @State private var currentPassword = ""
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var showCurrentPassword = false
    @State private var showNewPassword = false
    @State private var showConfirmPassword = false
    @State private var isSubmitting = false
    @State private var errorMessage = ""
    @State private var successMessage = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 12) {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 50))
                        .foregroundColor(Color(red: 0.43, green: 0.76, blue: 0.96))
                        .frame(width: 100, height: 100)
                        .background(Color(red: 0.43, green: 0.76, blue: 0.96).opacity(0.1))
                        .clipShape(Circle())

                    Text("Đổi mật khẩu")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.black)

                    Text("Nhập mật khẩu hiện tại và mật khẩu mới")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                .padding(.top, 20)

                // Form
                VStack(spacing: 20) {
                    // Current Password Field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Mật khẩu hiện tại")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray)

                        HStack {
                            if showCurrentPassword {
                                TextField("Nhập mật khẩu hiện tại", text: $currentPassword)
                            } else {
                                SecureField("Nhập mật khẩu hiện tại", text: $currentPassword)
                            }

                            Button(action: {
                                showCurrentPassword.toggle()
                            }) {
                                Image(systemName: showCurrentPassword ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                    }

                    // New Password Field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Mật khẩu mới")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray)

                        HStack {
                            if showNewPassword {
                                TextField("Nhập mật khẩu mới", text: $newPassword)
                            } else {
                                SecureField("Nhập mật khẩu mới", text: $newPassword)
                            }

                            Button(action: {
                                showNewPassword.toggle()
                            }) {
                                Image(systemName: showNewPassword ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)

                        // Password Requirements
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Mật khẩu phải có:")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                            Text("• Ít nhất 6 ký tự")
                                .font(.system(size: 11))
                                .foregroundColor(.gray)
                            Text("• Chứa chữ hoa, chữ thường và số")
                                .font(.system(size: 11))
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 4)
                    }

                    // Confirm Password Field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Xác nhận mật khẩu mới")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray)

                        HStack {
                            if showConfirmPassword {
                                TextField("Nhập lại mật khẩu mới", text: $confirmPassword)
                            } else {
                                SecureField("Nhập lại mật khẩu mới", text: $confirmPassword)
                            }

                            Button(action: {
                                showConfirmPassword.toggle()
                            }) {
                                Image(systemName: showConfirmPassword ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                    }

                    // Error Message
                    if !errorMessage.isEmpty {
                        HStack {
                            Image(systemName: "exclamationmark.circle.fill")
                                .foregroundColor(.red)
                            Text(errorMessage)
                                .font(.system(size: 14))
                                .foregroundColor(.red)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(8)
                    }

                    // Success Message
                    if !successMessage.isEmpty {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text(successMessage)
                                .font(.system(size: 14))
                                .foregroundColor(.green)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(8)
                    }

                    // Save Button
                    Button(action: handleSave) {
                        if isSubmitting {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                        } else {
                            Text("Đổi mật khẩu")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                        }
                    }
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
                    .disabled(isSubmitting || currentPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty)
                    .opacity((isSubmitting || currentPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) ? 0.6 : 1.0)
                }
                .padding(.horizontal, 20)
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
        .navigationTitle("Đổi mật khẩu")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func handleSave() {
        print("🔒 [ChangePasswordView] Changing password...")

        // Validation
        if currentPassword.isEmpty {
            errorMessage = "Vui lòng nhập mật khẩu hiện tại"
            return
        }

        if newPassword.count < 6 {
            errorMessage = "Mật khẩu mới phải có ít nhất 6 ký tự"
            return
        }

        if !isValidPassword(newPassword) {
            errorMessage = "Mật khẩu mới phải chứa chữ hoa, chữ thường và số"
            return
        }

        if newPassword != confirmPassword {
            errorMessage = "Mật khẩu mới và xác nhận mật khẩu không khớp"
            return
        }

        if newPassword == currentPassword {
            errorMessage = "Mật khẩu mới phải khác mật khẩu hiện tại"
            return
        }

        isSubmitting = true
        errorMessage = ""
        successMessage = ""

        Task {
            do {
                try await APIService.shared.changePassword(
                    currentPassword: currentPassword,
                    newPassword: newPassword,
                    confirmPassword: confirmPassword
                )

                await MainActor.run {
                    isSubmitting = false
                    successMessage = "Đổi mật khẩu thành công"
                    print("✅ [ChangePasswordView] Password changed successfully")

                    // Clear fields
                    currentPassword = ""
                    newPassword = ""
                    confirmPassword = ""

                    // Dismiss after 1.5 seconds
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        dismiss()
                    }
                }
            } catch {
                await MainActor.run {
                    isSubmitting = false
                    if let apiError = error as? APIError {
                        errorMessage = apiError.localizedDescription
                    } else {
                        errorMessage = "Không thể đổi mật khẩu. Vui lòng thử lại."
                    }
                    print("❌ [ChangePasswordView] Failed to change password: \(error.localizedDescription)")
                }
            }
        }
    }

    private func isValidPassword(_ password: String) -> Bool {
        // At least one uppercase, one lowercase, and one number
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).+$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
    }
}

#Preview {
    NavigationView {
        ChangePasswordView()
    }
}
