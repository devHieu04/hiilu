//
//  HomeView.swift
//  Hiilu
//
//  Created on 30/11/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var authManager = AuthManager.shared
    @State private var cards: [Card] = []
    @State private var isLoading = true
    @State private var errorMessage = ""
    @State private var selectedCardId: String?

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Xin chào,")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                            if let user = authManager.user {
                                Text(user.name)
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.black)
                            }
                        }
                        Spacer()
                        if !cards.isEmpty {
                            NavigationLink(destination: CreateCardView {
                                loadCards()
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 28))
                                    .foregroundColor(Color(red: 0.43, green: 0.76, blue: 0.96))
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)

                    // Loading state
                    if isLoading {
                        VStack(spacing: 16) {
                            ProgressView()
                            Text("Đang tải...")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 60)
                    }
                    // Error state
                    else if !errorMessage.isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: "exclamationmark.triangle")
                                .font(.system(size: 40))
                                .foregroundColor(.red)
                            Text(errorMessage)
                                .font(.system(size: 14))
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 60)
                        .padding(.horizontal, 20)
                    }
                    // Empty state
                    else if cards.isEmpty {
                        VStack(spacing: 20) {
                            Image(systemName: "creditcard")
                                .font(.system(size: 60))
                                .foregroundColor(.gray.opacity(0.5))
                            Text("Chưa có thẻ nào")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.black)
                            Text("Tạo thẻ đầu tiên của bạn để bắt đầu chia sẻ thông tin")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)

                            NavigationLink(destination: CreateCardView {
                                loadCards()
                            }) {
                                Text("Tạo thẻ mới")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 24)
                                    .padding(.vertical, 12)
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
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 60)
                    }
                    // Cards list
                    else {
                        VStack(spacing: 20) {
                            ForEach(cards) { card in
                                CardItemView(
                                    card: card,
                                    cardId: card.id,
                                    onEdit: {
                                        loadCards()
                                    },
                                    onPreview: {
                                        // Navigation handled by NavigationLink
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }
                .padding(.bottom, 20)
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
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            loadCards()
        }
    }

    private func loadCards() {
        print("📋 [HomeView] Loading cards...")
        isLoading = true
        errorMessage = ""

        Task {
            do {
                let cardsData = try await APIService.shared.getCards()
                await MainActor.run {
                    self.cards = cardsData
                    self.isLoading = false
                    print("✅ [HomeView] Loaded \(cardsData.count) cards")
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                    if let apiError = error as? APIError {
                        self.errorMessage = apiError.localizedDescription
                    } else {
                        self.errorMessage = "Không thể tải danh sách thẻ"
                    }
                    print("❌ [HomeView] Failed to load cards: \(error.localizedDescription)")
                }
            }
        }
    }
}

struct CardItemView: View {
    let card: Card
    let cardId: String
    let onEdit: () -> Void
    let onPreview: () -> Void
    @State private var showShareSheet = false

    var body: some View {
        VStack(spacing: 0) {
            // Card preview header
            ZStack {
                // Background with theme color or cover image
                if let coverImageUrl = card.coverImageUrl, let url = URL(string: coverImageUrl) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        RoundedRectangle(cornerRadius: 0)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(hex: card.theme?.color ?? "#0ea5e9") ?? Color.blue,
                                        Color(hex: card.theme?.color ?? "#0ea5e9")?.opacity(0.7) ?? Color.blue.opacity(0.7)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    }
                    .frame(height: 180)
                    .clipped()
                } else {
                    RoundedRectangle(cornerRadius: 0)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(hex: card.theme?.color ?? "#0ea5e9") ?? Color.blue,
                                    Color(hex: card.theme?.color ?? "#0ea5e9")?.opacity(0.7) ?? Color.blue.opacity(0.7)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(height: 180)
                }

                // Avatar and name overlay
                VStack(spacing: 12) {
                    // Avatar
                    if let avatarUrl = card.avatarUrl, let url = URL(string: avatarUrl) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            Circle()
                                .fill(Color.white.opacity(0.3))
                        }
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 4)
                        )
                        .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
                    } else {
                        Circle()
                            .fill(Color.white.opacity(0.3))
                            .frame(width: 100, height: 100)
                            .overlay(
                                Text(getInitials(card.ownerName))
                                    .font(.system(size: 36, weight: .bold))
                                    .foregroundColor(.white)
                            )
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: 4)
                            )
                            .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
                    }

                    Text(card.ownerName)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 2)
                }
                .padding(.top, 20)
            }

            // Card info section
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(card.cardName)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)

                    if let company = card.company {
                        HStack(spacing: 6) {
                            Image(systemName: "building.2")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                            Text(company)
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                    }

                    if let description = card.description {
                        Text(description)
                            .font(.system(size: 13))
                            .foregroundColor(.gray)
                            .lineLimit(2)
                            .padding(.top, 4)
                    }
                }

                // Action buttons
                VStack(spacing: 12) {
                    HStack(spacing: 12) {
                        NavigationLink(destination: CardPreviewFullView(card: card)) {
                            HStack(spacing: 6) {
                                Image(systemName: "eye.fill")
                                    .font(.system(size: 14))
                                Text("Xem trước")
                                    .font(.system(size: 14, weight: .medium))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color(hex: card.theme?.color ?? "#0ea5e9")?.opacity(0.1) ?? Color.blue.opacity(0.1))
                            .foregroundColor(Color(hex: card.theme?.color ?? "#0ea5e9") ?? Color.blue)
                            .cornerRadius(10)
                        }
                        .buttonStyle(PlainButtonStyle())

                        NavigationLink(destination: EditCardView(cardId: cardId) {
                            onEdit()
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: "pencil")
                                    .font(.system(size: 14))
                                Text("Chỉnh sửa")
                                    .font(.system(size: 14, weight: .semibold))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(
                                LinearGradient(
                                    colors: [
                                        Color(hex: card.theme?.color ?? "#0ea5e9") ?? Color.blue,
                                        Color(hex: card.theme?.color ?? "#0ea5e9")?.opacity(0.8) ?? Color.blue.opacity(0.8)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }

                    Button(action: {
                        if card.shareUuid == nil || card.qrCodeUrl == nil {
                            // Show alert or handle error
                            return
                        }
                        showShareSheet = true
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "square.and.arrow.up")
                                .font(.system(size: 14))
                            Text("Chia sẻ")
                                .font(.system(size: 14, weight: .semibold))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
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
                        .cornerRadius(10)
                    }
                }
            }
            .padding(20)
            .background(Color.white)
        }
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.15), radius: 12, x: 0, y: 6)
        .sheet(isPresented: $showShareSheet) {
            CardShareSheet(card: card)
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

extension Color {
    init?(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return nil
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
