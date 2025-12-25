//
//  CreateCardView.swift
//  Hiilu
//
//  Created on 30/11/25.
//

import SwiftUI
import UIKit

struct CreateCardView: View {
    let onSave: (() -> Void)?
    @Environment(\.dismiss) var dismiss
    @StateObject private var authManager = AuthManager.shared

    init(onSave: (() -> Void)? = nil) {
        self.onSave = onSave
    }

    @State private var isSubmitting = false
    @State private var errorMessage = ""
    @State private var activeTab: TabType = .intro

    // Form state
    @State private var cardName = ""
    @State private var ownerName = ""
    @State private var email = ""
    @State private var phoneNumber = ""
    @State private var company = ""
    @State private var address = ""
    @State private var description = ""
    @State private var themeColor = "#0ea5e9"
    @State private var links: [Link] = []

    // Image states
    @State private var avatarImage: UIImage?
    @State private var coverImage: UIImage?
    @State private var showImagePicker = false
    @State private var imagePickerType: ImagePickerType = .avatar

    // Link editor
    @State private var newLinkTitle = ""
    @State private var newLinkUrl = ""
    @State private var showAddLink = false

    enum TabType {
        case intro, links, preview
    }

    enum ImagePickerType {
        case avatar, cover
    }

    let themeColors = [
        ("Không màu", ""),
        ("Xanh dương", "#0ea5e9"),
        ("Tím", "#8b5cf6"),
        ("Hồng", "#f472b6"),
        ("Đỏ", "#ef4444"),
        ("Cam", "#f97316"),
        ("Vàng", "#fbbf24"),
        ("Xanh lá", "#34d399")
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    // Tabs
                    HStack(spacing: 0) {
                        TabButton(title: "Thông tin", isActive: activeTab == .intro) {
                            activeTab = .intro
                        }
                        TabButton(title: "Liên kết", isActive: activeTab == .links) {
                            activeTab = .links
                        }
                        TabButton(title: "Xem trước", isActive: activeTab == .preview) {
                            activeTab = .preview
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)

                    // Tab content
                    if activeTab == .preview {
                        // Preview tab
                        CardPreviewView(
                            card: createPreviewCard(),
                            avatarImage: avatarImage,
                            coverImage: coverImage,
                            avatarPreview: nil,
                            coverImagePreview: nil
                        )
                        .padding(.top, 20)
                    } else {
                        // Form tabs
                        VStack(spacing: 24) {
                            if !errorMessage.isEmpty {
                                Text(errorMessage)
                                    .font(.system(size: 14))
                                    .foregroundColor(.red)
                                    .padding(.horizontal, 20)
                                    .padding(.top, 20)
                            }

                            if activeTab == .intro {
                                introFormView
                            } else {
                                linksFormView
                            }
                        }
                        .padding(.top, 20)
                    }
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
            .navigationTitle("Tạo thẻ mới")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: handleSave) {
                        if isSubmitting {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .frame(width: 20, height: 20)
                        } else {
                            Text("Tạo")
                                .fontWeight(.semibold)
                        }
                    }
                    .disabled(isSubmitting || cardName.isEmpty || ownerName.isEmpty)
                    .opacity((isSubmitting || cardName.isEmpty || ownerName.isEmpty) ? 0.6 : 1.0)
                }
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: imagePickerType == .avatar ? $avatarImage : $coverImage)
            }
        }
    }

    // MARK: - Intro Form View
    private var introFormView: some View {
        VStack(spacing: 20) {
            // Avatar upload
            VStack(spacing: 12) {
                Text("Ảnh đại diện")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Button(action: {
                    imagePickerType = .avatar
                    showImagePicker = true
                }) {
                    ZStack {
                        if let avatarImage = avatarImage {
                            Image(uiImage: avatarImage)
                                .resizable()
                                .scaledToFill()
                        } else {
                            Circle()
                                .fill(Color.gray.opacity(0.2))
                        }

                        Circle()
                            .stroke(Color.white, lineWidth: 4)

                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Image(systemName: "camera.fill")
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                                    .padding(8)
                                    .background(Color.black.opacity(0.6))
                                    .clipShape(Circle())
                                    .padding(8)
                            }
                        }
                    }
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                }
            }
            .padding(.horizontal, 20)

            // Cover image upload
            VStack(spacing: 12) {
                Text("Ảnh bìa")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Button(action: {
                    imagePickerType = .cover
                    showImagePicker = true
                }) {
                    ZStack {
                        if let coverImage = coverImage {
                            Image(uiImage: coverImage)
                                .resizable()
                                .scaledToFill()
                        } else {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color(hex: themeColor) ?? Color.blue,
                                            Color(hex: themeColor)?.opacity(0.7) ?? Color.blue.opacity(0.7)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        }

                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Image(systemName: "camera.fill")
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                                    .padding(8)
                                    .background(Color.black.opacity(0.6))
                                    .clipShape(Circle())
                                    .padding(8)
                            }
                        }
                    }
                    .frame(height: 180)
                    .cornerRadius(12)
                }
            }
            .padding(.horizontal, 20)

            // Form fields
            VStack(spacing: 16) {
                FormField(label: "Tên thẻ *", text: $cardName, placeholder: "Nhập tên thẻ")
                FormField(label: "Tên chủ thẻ *", text: $ownerName, placeholder: "Nhập tên chủ thẻ")
                FormField(label: "Email", text: $email, placeholder: "Nhập email", keyboardType: .emailAddress)
                FormField(label: "Số điện thoại", text: $phoneNumber, placeholder: "Nhập số điện thoại", keyboardType: .phonePad)
                FormField(label: "Công ty", text: $company, placeholder: "Nhập tên công ty")
                FormField(label: "Địa chỉ", text: $address, placeholder: "Nhập địa chỉ")
                FormField(label: "Mô tả", text: $description, placeholder: "Nhập mô tả", isMultiline: true)
            }
            .padding(.horizontal, 20)

            // Theme color picker
            VStack(alignment: .leading, spacing: 12) {
                Text("Màu chủ đạo")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.black)
                    .padding(.horizontal, 20)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(themeColors, id: \.0) { colorOption in
                            ColorOptionView(
                                label: colorOption.0,
                                color: Color(hex: colorOption.1),
                                isSelected: themeColor == colorOption.1
                            ) {
                                themeColor = colorOption.1
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
            .padding(.vertical, 20)
        }
    }

    // MARK: - Links Form View
    private var linksFormView: some View {
        VStack(spacing: 20) {
            // Add link section
            VStack(spacing: 12) {
                Button(action: {
                    showAddLink.toggle()
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 18))
                        Text("Thêm liên kết")
                            .font(.system(size: 16, weight: .medium))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color(hex: themeColor)?.opacity(0.1) ?? Color.blue.opacity(0.1))
                    .foregroundColor(Color(hex: themeColor) ?? Color.blue)
                    .cornerRadius(10)
                }
                .padding(.horizontal, 20)

                if showAddLink {
                    VStack(spacing: 12) {
                        TextField("Tiêu đề", text: $newLinkTitle)
                            .textFieldStyle(CustomTextFieldStyle())
                        TextField("URL", text: $newLinkUrl)
                            .textFieldStyle(CustomTextFieldStyle())
                            .keyboardType(.URL)
                            .autocapitalization(.none)

                        HStack(spacing: 12) {
                            Button("Hủy") {
                                showAddLink = false
                                newLinkTitle = ""
                                newLinkUrl = ""
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(Color.gray.opacity(0.1))
                            .foregroundColor(.gray)
                            .cornerRadius(8)

                            Button("Thêm") {
                                if !newLinkTitle.isEmpty && !newLinkUrl.isEmpty {
                                    links.append(Link(title: newLinkTitle, url: newLinkUrl, icon: nil))
                                    newLinkTitle = ""
                                    newLinkUrl = ""
                                    showAddLink = false
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(Color(hex: themeColor) ?? Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }

            // Links list
            if links.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "link")
                        .font(.system(size: 40))
                        .foregroundColor(.gray.opacity(0.5))
                    Text("Chưa có liên kết nào")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
            } else {
                VStack(spacing: 12) {
                    ForEach(Array(links.enumerated()), id: \.offset) { index, link in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(link.title)
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.black)
                                Text(link.url)
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                                    .lineLimit(1)
                            }
                            Spacer()
                            Button(action: {
                                links.remove(at: index)
                            }) {
                                Image(systemName: "trash")
                                    .font(.system(size: 16))
                                    .foregroundColor(.red)
                            }
                        }
                        .padding(16)
                        .background(Color.white)
                        .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }

    // MARK: - Helper Functions
    private func createPreviewCard() -> Card {
        return Card(
            id: "",
            userId: authManager.user?.id ?? "",
            cardName: cardName.isEmpty ? "Tên thẻ" : cardName,
            ownerName: ownerName.isEmpty ? "Tên chủ thẻ" : ownerName,
            email: email.isEmpty ? nil : email,
            phoneNumber: phoneNumber.isEmpty ? nil : phoneNumber,
            company: company.isEmpty ? nil : company,
            address: address.isEmpty ? nil : address,
            description: description.isEmpty ? nil : description,
            avatarUrl: nil,
            coverImageUrl: nil,
            theme: Theme(color: themeColor.isEmpty ? nil : themeColor, icon: nil),
            links: links.isEmpty ? nil : links,
            qrCodeUrl: nil,
            shareUuid: nil,
            isActive: true,
            viewCount: 0,
            createdAt: "",
            updatedAt: ""
        )
    }

    private func handleSave() {
        print("💾 [CreateCardView] Creating card...")

        // Validation
        if cardName.isEmpty || ownerName.isEmpty {
            errorMessage = "Vui lòng nhập tên thẻ và tên chủ thẻ"
            return
        }

        isSubmitting = true
        errorMessage = ""

        Task {
            do {
                let _ = try await APIService.shared.createCard(
                    cardName: cardName,
                    ownerName: ownerName,
                    email: email.isEmpty ? nil : email,
                    phoneNumber: phoneNumber.isEmpty ? nil : phoneNumber,
                    company: company.isEmpty ? nil : company,
                    address: address.isEmpty ? nil : address,
                    description: description.isEmpty ? nil : description,
                    themeColor: themeColor.isEmpty ? nil : themeColor,
                    links: links,
                    avatarImage: avatarImage,
                    coverImage: coverImage
                )

                await MainActor.run {
                    isSubmitting = false
                    print("✅ [CreateCardView] Card created successfully")
                    onSave?()
                    dismiss()
                }
            } catch {
                await MainActor.run {
                    isSubmitting = false
                    if let apiError = error as? APIError {
                        errorMessage = apiError.localizedDescription
                    } else {
                        errorMessage = "Không thể tạo thẻ. Vui lòng thử lại."
                    }
                    print("❌ [CreateCardView] Failed to create card: \(error.localizedDescription)")
                }
            }
        }
    }
}
