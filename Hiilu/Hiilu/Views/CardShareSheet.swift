//
//  CardShareSheet.swift
//  Hiilu
//
//  Created on 30/11/25.
//

import SwiftUI
import UIKit

struct CardShareSheet: View {
    let card: Card
    @Environment(\.dismiss) var dismiss
    @State private var copyStatus: CopyStatus = .idle
    @State private var shareSheetPresented = false
    @StateObject private var nfcService = NFCService.shared
    @State private var nfcWriteStatus: String?

    enum CopyStatus {
        case idle, success, error
    }

    private var shareLink: String {
        // Production frontend URL
        let frontendURL = "https://hilu.pics"
        return "\(frontendURL)/card/\(card.shareUuid ?? "")"
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Header text
                VStack(spacing: 8) {
                    Text("Quét mã QR để xem trang bio của bạn")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 20)

                // QR Code
                if let qrCodeUrl = card.qrCodeUrl, let url = URL(string: qrCodeUrl) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 200, height: 200)
                    .background(Color.white)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
                } else {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.1))
                        .frame(width: 200, height: 200)
                        .overlay(
                            VStack(spacing: 8) {
                                Image(systemName: "qrcode")
                                    .font(.system(size: 40))
                                    .foregroundColor(.gray)
                                Text("Đang tải QR code...")
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                            }
                        )
                }

                Divider()
                    .padding(.horizontal, 20)

                // Link section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Đường dẫn đến bio của bạn")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.black)

                    HStack(spacing: 12) {
                        Text(shareLink)
                            .font(.system(size: 13))
                            .foregroundColor(.gray)
                            .lineLimit(1)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)

                        Button(action: handleCopy) {
                            Text(copyStatus == .success ? "Đã sao chép" : "Sao chép")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(copyStatus == .success ? .green : Color(red: 0.43, green: 0.76, blue: 0.96))
                        }
                    }
                }
                .padding(.horizontal, 20)

                // Action buttons
                VStack(spacing: 12) {
                    Button(action: handleShare) {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                                .font(.system(size: 16))
                            Text("Chia sẻ qua các nền tảng")
                                .font(.system(size: 16, weight: .semibold))
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
                    }

                    Button(action: handleWriteNFC) {
                        HStack {
                            Image(systemName: nfcService.isWriting ? "hourglass" : "sensor.tag.radiowaves.forward.fill")
                                .font(.system(size: 16))
                            Text(nfcService.isWriting ? "Đang ghi..." : "Nạp thẻ NFC")
                                .font(.system(size: 16, weight: .semibold))
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
                    }
                    .disabled(nfcService.isWriting)

                    Button(action: handleCopy) {
                        HStack {
                            Image(systemName: copyStatus == .success ? "checkmark.circle.fill" : "doc.on.doc")
                                .font(.system(size: 16))
                            Text(copyStatus == .success ? "Đã sao chép liên kết" : "Sao chép liên kết")
                                .font(.system(size: 16, weight: .medium))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.gray.opacity(0.1))
                        .foregroundColor(copyStatus == .success ? .green : .black)
                        .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)

                // NFC Write Status
                if let status = nfcWriteStatus {
                    Text(status)
                        .font(.system(size: 14))
                        .foregroundColor(status.contains("thành công") ? .green : .red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 10)
                }

                Spacer()
            }
            .background(Color.white)
            .navigationTitle("Chia sẻ thẻ")
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
            .sheet(isPresented: $shareSheetPresented) {
                ShareSheet(activityItems: [shareLink])
            }
        }
    }

    private func handleCopy() {
        UIPasteboard.general.string = shareLink
        copyStatus = .success

        // Reset after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            copyStatus = .idle
        }
    }

    private func handleShare() {
        shareSheetPresented = true
    }

    private func handleWriteNFC() {
        guard card.shareUuid != nil else {
            nfcWriteStatus = "Thẻ chưa có link chia sẻ"
            return
        }

        nfcWriteStatus = nil
        nfcService.startWriting(url: shareLink) { success, error in
            if success {
                nfcWriteStatus = "Đã ghi thành công vào thẻ NFC!"
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    nfcWriteStatus = nil
                }
            } else {
                nfcWriteStatus = error ?? "Không thể ghi vào thẻ NFC"
            }
        }
    }
}

// MARK: - ShareSheet Helper
struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities
        )
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
