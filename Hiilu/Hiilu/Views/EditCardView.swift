//
//  EditCardView.swift
//  Hiilu
//
//  Created on 30/11/25.
//

import SwiftUI
import UIKit

struct EditCardView: View {
    let cardId: String
    let onSave: (() -> Void)?
    @Environment(\.dismiss) var dismiss
    @StateObject private var authManager = AuthManager.shared

    init(cardId: String, onSave: (() -> Void)? = nil) {
        self.cardId = cardId
        self.onSave = onSave
    }

    @State private var card: Card?
    @State private var isLoading = true
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
    @State private var avatarPreview: String?
    @State private var coverImagePreview: String?
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
            ZStack {
                if isLoading {
                    VStack(spacing: 16) {
                        ProgressView()
                        Text("Đang tải...")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                } else if card != nil {
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
                                    avatarPreview: avatarPreview,
                                    coverImagePreview: coverImagePreview
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
                } else {
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 40))
                            .foregroundColor(.red)
                        Text("Không thể tải thông tin thẻ")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
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
            .navigationTitle("Chỉnh sửa thẻ")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: handleSave) {
                        if isSubmitting {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .frame(width: 20, height: 20)
                        } else {
                            Text("Lưu")
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
            .onAppear {
                loadCard()
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
                        } else if let avatarPreview = avatarPreview, let url = URL(string: avatarPreview) {
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                            } placeholder: {
                                Circle()
                                    .fill(Color.gray.opacity(0.2))
                            }
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
                        } else if let coverImagePreview = coverImagePreview, let url = URL(string: coverImagePreview) {
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                            } placeholder: {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.gray.opacity(0.2))
                            }
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
                    .frame(height: 150)
                    .cornerRadius(12)
                }
            }
            .padding(.horizontal, 20)

            // Form fields
            VStack(spacing: 16) {
                FormField(label: "Tên thẻ", text: $cardName, placeholder: "Nhập tên thẻ")
                FormField(label: "Tên chủ thẻ", text: $ownerName, placeholder: "Nhập tên chủ thẻ")
                FormField(label: "Email", text: $email, placeholder: "Nhập email", keyboardType: .emailAddress)
                FormField(label: "Số điện thoại", text: $phoneNumber, placeholder: "Nhập số điện thoại", keyboardType: .phonePad)
                FormField(label: "Công việc", text: $company, placeholder: "Nhập công việc")
                FormField(label: "Địa chỉ", text: $address, placeholder: "Nhập địa chỉ")
                FormField(label: "Mô tả", text: $description, placeholder: "Nhập mô tả", isMultiline: true)

                // Theme color picker
                VStack(alignment: .leading, spacing: 8) {
                    Text("Màu chủ đạo")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.black)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(themeColors, id: \.1) { color in
                                ColorOptionView(
                                    label: color.0,
                                    color: color.1.isEmpty ? nil : Color(hex: color.1),
                                    isSelected: themeColor == color.1
                                ) {
                                    themeColor = color.1
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
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
    private func loadCard() {
        print("📥 [EditCardView] Loading card: \(cardId)")
        isLoading = true

        Task {
            do {
                let cardData = try await APIService.shared.getCard(id: cardId)
                await MainActor.run {
                    self.card = cardData
                    populateForm(from: cardData)
                    self.isLoading = false
                    print("✅ [EditCardView] Card loaded successfully")
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                    self.errorMessage = "Không thể tải thông tin thẻ"
                    print("❌ [EditCardView] Failed to load card: \(error.localizedDescription)")
                }
            }
        }
    }

    private func populateForm(from card: Card) {
        cardName = card.cardName
        ownerName = card.ownerName
        email = card.email ?? ""
        phoneNumber = card.phoneNumber ?? ""
        company = card.company ?? ""
        address = card.address ?? ""
        description = card.description ?? ""
        themeColor = card.theme?.color ?? "#0ea5e9"
        links = card.links ?? []
        avatarPreview = card.avatarUrl
        coverImagePreview = card.coverImageUrl
    }

    private func createPreviewCard() -> Card {
        return Card(
            id: card?.id ?? "",
            userId: card?.userId ?? "",
            cardName: cardName.isEmpty ? card?.cardName ?? "" : cardName,
            ownerName: ownerName.isEmpty ? card?.ownerName ?? "" : ownerName,
            email: email.isEmpty ? nil : email,
            phoneNumber: phoneNumber.isEmpty ? nil : phoneNumber,
            company: company.isEmpty ? nil : company,
            address: address.isEmpty ? nil : address,
            description: description.isEmpty ? nil : description,
            avatarUrl: avatarImage != nil ? nil : avatarPreview,
            coverImageUrl: coverImage != nil ? nil : coverImagePreview,
            theme: Theme(color: themeColor.isEmpty ? nil : themeColor, icon: nil),
            links: links.isEmpty ? nil : links,
            qrCodeUrl: card?.qrCodeUrl,
            shareUuid: card?.shareUuid,
            isActive: card?.isActive ?? true,
            viewCount: card?.viewCount ?? 0,
            createdAt: card?.createdAt ?? "",
            updatedAt: card?.updatedAt ?? ""
        )
    }

    private func handleSave() {
        print("💾 [EditCardView] Saving card...")

        // Validation
        if cardName.isEmpty || ownerName.isEmpty {
            errorMessage = "Vui lòng nhập tên thẻ và tên chủ thẻ"
            return
        }

        isSubmitting = true
        errorMessage = ""

        Task {
            do {
                try await APIService.shared.updateCard(
                    id: cardId,
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
                    print("✅ [EditCardView] Card updated successfully")
                    onSave?()
                    dismiss()
                }
            } catch {
                await MainActor.run {
                    isSubmitting = false
                    if let apiError = error as? APIError {
                        errorMessage = apiError.localizedDescription
                    } else {
                        errorMessage = "Không thể cập nhật thẻ. Vui lòng thử lại."
                    }
                    print("❌ [EditCardView] Failed to update card: \(error.localizedDescription)")
                }
            }
        }
    }
}

// MARK: - Supporting Views
struct TabButton: View {
    let title: String
    let isActive: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: isActive ? .semibold : .regular))
                .foregroundColor(isActive ? .black : .gray)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .overlay(
                    Rectangle()
                        .frame(height: 2)
                        .foregroundColor(isActive ? Color(red: 0.43, green: 0.76, blue: 0.96) : Color.clear),
                    alignment: .bottom
                )
        }
    }
}

struct FormField: View {
    let label: String
    @Binding var text: String
    let placeholder: String
    var keyboardType: UIKeyboardType = .default
    var isMultiline: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.black)

            if isMultiline {
                TextEditor(text: $text)
                    .frame(height: 100)
                    .padding(8)
                    .background(Color.white)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
            } else {
                TextField(placeholder, text: $text)
                    .textFieldStyle(CustomTextFieldStyle())
                    .keyboardType(keyboardType)
                    .autocapitalization(keyboardType == .emailAddress ? .none : .sentences)
            }
        }
        .padding(.horizontal, 20)
    }
}

struct ColorOptionView: View {
    let label: String
    let color: Color?
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                ZStack {
                    Circle()
                        .fill(color ?? Color.gray.opacity(0.3))
                        .frame(width: 40, height: 40)

                    if isSelected {
                        Circle()
                            .stroke(Color(red: 0.43, green: 0.76, blue: 0.96), lineWidth: 3)
                            .frame(width: 40, height: 40)
                    }
                }

                Text(label)
                    .font(.system(size: 10))
                    .foregroundColor(.black)
            }
        }
    }
}

struct CardPreviewView: View {
    let card: Card
    let avatarImage: UIImage?
    let coverImage: UIImage?
    let avatarPreview: String?
    let coverImagePreview: String?

    @State private var activeTab: PreviewTab = .intro

    enum PreviewTab {
        case intro, links
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Cover image section
                ZStack {
                    if let coverImage = coverImage {
                        Image(uiImage: coverImage)
                            .resizable()
                            .scaledToFill()
                    } else if let coverImagePreview = coverImagePreview, let url = URL(string: coverImagePreview) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            RoundedRectangle(cornerRadius: 0)
                                .fill(Color(hex: card.theme?.color ?? "#0ea5e9") ?? Color.blue)
                        }
                    } else {
                        RoundedRectangle(cornerRadius: 0)
                            .fill(Color(hex: card.theme?.color ?? "#0ea5e9") ?? Color.blue)
                    }
                }
                .frame(height: 160)
                .clipped()

                // Avatar
                VStack(spacing: 12) {
                    if let avatarImage = avatarImage {
                        Image(uiImage: avatarImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 4))
                            .shadow(radius: 8)
                    } else if let avatarPreview = avatarPreview, let url = URL(string: avatarPreview) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            Circle()
                                .fill(Color.gray.opacity(0.3))
                        }
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                        .shadow(radius: 8)
                    } else {
                        Circle()
                            .fill(Color(hex: card.theme?.color ?? "#0ea5e9") ?? Color.blue)
                            .frame(width: 100, height: 100)
                            .overlay(
                                Text(getInitials(card.ownerName))
                                    .font(.system(size: 36, weight: .bold))
                                    .foregroundColor(.white)
                            )
                            .overlay(Circle().stroke(Color.white, lineWidth: 4))
                            .shadow(radius: 8)
                    }

                    Text(card.ownerName)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.black)

                    if let description = card.description {
                        Text(description)
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                    }
                }
                .padding(.top, -50)
                .padding(.bottom, 20)

                // Tabs
                HStack(spacing: 0) {
                    TabButton(title: "Giới thiệu", isActive: activeTab == .intro) {
                        activeTab = .intro
                    }
                    TabButton(title: "Liên kết", isActive: activeTab == .links) {
                        activeTab = .links
                    }
                }
                .padding(.horizontal, 20)

                // Tab content
                if activeTab == .intro {
                    introPreviewContent
                } else {
                    linksPreviewContent
                }
            }
        }
        .background(Color.white)
        .cornerRadius(20)
        .padding(.horizontal, 20)
    }

    private var introPreviewContent: some View {
        VStack(spacing: 12) {
            if let company = card.company {
                PreviewItemView(icon: "building.2", text: company, color: .orange)
            }
            if let email = card.email {
                PreviewItemView(icon: "envelope.fill", text: email, color: .blue)
            }
            if let phoneNumber = card.phoneNumber {
                PreviewItemView(icon: "phone.fill", text: phoneNumber, color: .green)
            }
            if let address = card.address {
                PreviewItemView(icon: "location.fill", text: address, color: .purple)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
    }

    private var linksPreviewContent: some View {
        VStack(spacing: 12) {
            if let links = card.links, !links.isEmpty {
                ForEach(Array(links.enumerated()), id: \.offset) { _, link in
                    HStack(spacing: 12) {
                        Image(systemName: "link")
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                            .frame(width: 32, height: 32)
                            .background(Color(hex: card.theme?.color ?? "#0ea5e9") ?? Color.blue)
                            .cornerRadius(8)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(link.title)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.black)
                            Text(link.url)
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                                .lineLimit(1)
                        }

                        Spacer()
                    }
                    .padding(12)
                    .background(Color.gray.opacity(0.05))
                    .cornerRadius(10)
                }
            } else {
                Text("Chưa có liên kết nào")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .padding(.vertical, 40)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
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

struct PreviewItemView: View {
    let icon: String
    let text: String
    let color: Color

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(.white)
                .frame(width: 28, height: 28)
                .background(color)
                .cornerRadius(7)

            Text(text)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.black)

            Spacer()
        }
        .padding(12)
        .background(Color.gray.opacity(0.05))
        .cornerRadius(10)
    }
}

// MARK: - Image Picker
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.dismiss) var dismiss

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
            }
            parent.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}
