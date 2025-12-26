//
//  NFCReadView.swift
//  Hiilu
//
//  Created on 30/11/25.
//

import SwiftUI

struct NFCReadView: View {
    @StateObject private var nfcService = NFCService.shared
    @State private var card: Card?
    @State private var isLoading = false
    @State private var errorMessage = ""
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            ZStack {
                if isLoading {
                    VStack(spacing: 16) {
                        ProgressView()
                            .scaleEffect(1.5)
                        Text("Đang tải thẻ...")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                    }
                } else if let card = card {
                    ScrollView {
                        CardPreviewContent(card: card)
                    }
                    .background(Color.white)
                } else {
                    VStack(spacing: 24) {
                        Image(systemName: "sensor.tag.radiowaves.forward")
                            .font(.system(size: 60))
                            .foregroundColor(Color(red: 0.43, green: 0.76, blue: 0.96))

                        Text("Đọc thẻ NFC")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.black)

                        Text("Đưa iPhone gần thẻ NFC để đọc thông tin")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)

                        if !errorMessage.isEmpty {
                            Text(errorMessage)
                                .font(.system(size: 14))
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                        }

                        Button(action: startReading) {
                            HStack {
                                Image(systemName: "sensor.tag.radiowaves.forward.fill")
                                    .font(.system(size: 18))
                                Text("Bắt đầu đọc")
                                    .font(.system(size: 16, weight: .semibold))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
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
                        }
                        .padding(.horizontal, 40)
                        .disabled(nfcService.isReading)
                    }
                    .padding(.vertical, 60)
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
            .navigationTitle("Đọc thẻ NFC")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .onAppear {
            startReading()
        }
    }

    private func startReading() {
        errorMessage = ""
        isLoading = false

        nfcService.startReading { url in
            guard let urlString = url else {
                if let error = nfcService.readError {
                    errorMessage = error
                }
                return
            }

            // Open URL in Safari instead of calling API
            print("📱 Opening card URL in Safari: \(urlString)")

            if let url = URL(string: urlString) {
                DispatchQueue.main.async {
                    UIApplication.shared.open(url)
                    // Close this view after opening Safari
                    self.dismiss()
                }
            } else {
                errorMessage = "URL không hợp lệ"
            }
        }
    }
}

// MARK: - Card Preview Content (without navigation)
struct CardPreviewContent: View {
    let card: Card
    @State private var activeTab: PreviewTab = .intro

    enum PreviewTab {
        case intro, links
    }

    var body: some View {
        VStack(spacing: 0) {
            // Cover image section
            ZStack(alignment: .bottom) {
                if let coverImageUrl = card.coverImageUrl, let url = URL(string: coverImageUrl) {
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

            // Avatar - overlapping
            VStack(spacing: 12) {
                if let avatarUrl = card.avatarUrl, let url = URL(string: avatarUrl) {
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
            .padding(.bottom, 20)

            // Tab content
            if activeTab == .intro {
                introContent
            } else {
                linksContent
            }
        }
        .background(Color.white)
    }

    private var introContent: some View {
        VStack(spacing: 12) {
            if let company = card.company {
                PreviewItemView(icon: "building.2", text: company, color: .orange)
            }
            if let email = card.email {
                if let mailtoURL = URL(string: "mailto:\(email)") {
                    SwiftUI.Link(destination: mailtoURL) {
                        HStack {
                            PreviewItemView(icon: "envelope.fill", text: email, color: .blue)
                            Spacer()
                            Image(systemName: "arrow.up.right.square")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                        }
                    }
                } else {
                    PreviewItemView(icon: "envelope.fill", text: email, color: .blue)
                }
            }
            if let phoneNumber = card.phoneNumber {
                let phoneUrl = phoneNumber.replacingOccurrences(of: " ", with: "")
                    .replacingOccurrences(of: "-", with: "")
                    .replacingOccurrences(of: "(", with: "")
                    .replacingOccurrences(of: ")", with: "")
                if let telURL = URL(string: "tel:\(phoneUrl)") {
                    SwiftUI.Link(destination: telURL) {
                        HStack {
                            PreviewItemView(icon: "phone.fill", text: phoneNumber, color: .green)
                            Spacer()
                            Image(systemName: "arrow.up.right.square")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                        }
                    }
                } else {
                    PreviewItemView(icon: "phone.fill", text: phoneNumber, color: .green)
                }
            }
            if let address = card.address {
                PreviewItemView(icon: "location.fill", text: address, color: .purple)
            }

            if card.company == nil && card.email == nil && card.phoneNumber == nil && card.address == nil {
                Text("Chưa có thông tin giới thiệu")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .padding(.vertical, 40)
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
    }

    private var linksContent: some View {
        VStack(spacing: 12) {
            if let links = card.links, !links.isEmpty {
                ForEach(Array(links.enumerated()), id: \.offset) { _, link in
                    linkItemView(link: link)
                }
            } else {
                Text("Chưa có liên kết nào")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .padding(.vertical, 40)
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
    }

    private func linkItemView(link: Link) -> some View {
        Group {
            if let url = URL(string: link.url) {
                SwiftUI.Link(destination: url) {
                    linkContent(link: link)
                }
            } else {
                linkContent(link: link)
            }
        }
    }

    private func linkContent(link: Link) -> some View {
        HStack(spacing: 12) {
            Image(systemName: getLinkIcon(link.url))
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

            Image(systemName: "arrow.up.right.square")
                .font(.system(size: 14))
                .foregroundColor(.gray)
        }
        .padding(12)
        .background(Color.gray.opacity(0.05))
        .cornerRadius(10)
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

    private func getLinkIcon(_ url: String) -> String {
        let lowercased = url.lowercased()
        if lowercased.contains("facebook") { return "f.circle.fill" }
        if lowercased.contains("twitter") || lowercased.contains("x.com") { return "at" }
        if lowercased.contains("instagram") { return "camera.fill" }
        if lowercased.contains("linkedin") { return "person.2.fill" }
        if lowercased.contains("youtube") { return "play.circle.fill" }
        if lowercased.contains("github") { return "chevron.left.forwardslash.chevron.right" }
        if lowercased.contains("mailto") { return "envelope.fill" }
        if lowercased.contains("tel") { return "phone.fill" }
        return "link"
    }
}
