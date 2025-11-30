//
//  EditProfileView.swift
//  Hiilu
//
//  Created on 30/11/25.
//

import SwiftUI

struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var authManager = AuthManager.shared

    @State private var name: String = ""
    @State private var email: String = ""
    @State private var isSubmitting = false
    @State private var errorMessage = ""
    @State private var successMessage = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
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
                            Text(getInitials(name.isEmpty ? authManager.user?.name ?? "" : name))
                                .font(.system(size: 36, weight: .bold))
                                .foregroundColor(.white)
                        )
                        .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
                }
                .padding(.top, 20)

                // Form
                VStack(spacing: 20) {
                    // Name Field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Họ và tên")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray)

                        TextField("Nhập họ và tên", text: $name)
                            .textFieldStyle(CustomTextFieldStyle())
                    }

                    // Email Field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Email")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray)

                        TextField("Nhập email", text: $email)
                            .textFieldStyle(CustomTextFieldStyle())
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
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
                            Text("Lưu thay đổi")
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
                    .disabled(isSubmitting || name.isEmpty || email.isEmpty)
                    .opacity((isSubmitting || name.isEmpty || email.isEmpty) ? 0.6 : 1.0)
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
        .navigationTitle("Thông tin cá nhân")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if let user = authManager.user {
                name = user.name
                email = user.email
            }
        }
    }

    private func handleSave() {
        print("💾 [EditProfileView] Saving profile...")

        // Validation
        if name.count < 2 {
            errorMessage = "Họ và tên phải có ít nhất 2 ký tự"
            return
        }

        if !isValidEmail(email) {
            errorMessage = "Email không hợp lệ"
            return
        }

        isSubmitting = true
        errorMessage = ""
        successMessage = ""

        Task {
            do {
                let updatedUser = try await APIService.shared.updateProfile(
                    name: name,
                    email: email
                )

                await MainActor.run {
                    isSubmitting = false
                    successMessage = "Cập nhật thông tin thành công"
                    print("✅ [EditProfileView] Profile updated successfully")

                    // Update auth manager
                    authManager.user = updatedUser

                    // Dismiss after 1 second
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        dismiss()
                    }
                }
            } catch {
                await MainActor.run {
                    isSubmitting = false
                    if let apiError = error as? APIError {
                        errorMessage = apiError.localizedDescription
                    } else {
                        errorMessage = "Không thể cập nhật thông tin. Vui lòng thử lại."
                    }
                    print("❌ [EditProfileView] Failed to update profile: \(error.localizedDescription)")
                }
            }
        }
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
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

#Preview {
    NavigationView {
        EditProfileView()
    }
}
