//
//  NFCService.swift
//  Hiilu
//
//  Created on 30/11/25.
//

import Foundation
import CoreNFC
import UIKit

class NFCService: NSObject, ObservableObject {
    static let shared = NFCService()

    @Published var isReading = false
    @Published var isWriting = false
    @Published var lastReadURL: String?
    @Published var writeError: String?
    @Published var readError: String?

    private var readerSession: NFCNDEFReaderSession?
    private var urlToWrite: String?
    private var onReadComplete: ((String?) -> Void)?
    private var onWriteComplete: ((Bool, String?) -> Void)?

    private override init() {
        super.init()
    }

    // MARK: - Read NFC Tag
    func startReading(completion: @escaping (String?) -> Void) {
        guard NFCNDEFReaderSession.readingAvailable else {
            DispatchQueue.main.async {
                self.readError = "NFC không khả dụng trên thiết bị này"
                completion(nil)
            }
            return
        }

        onReadComplete = completion
        isReading = true
        readError = nil

        // Set invalidateAfterFirstRead to false to manually handle reading
        readerSession = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: false)
        readerSession?.alertMessage = "Đưa iPhone gần thẻ NFC để đọc"
        readerSession?.begin()
    }

    func stopReading() {
        readerSession?.invalidate()
        readerSession = nil
        isReading = false
    }

    // MARK: - Write NFC Tag
    func startWriting(url: String, completion: @escaping (Bool, String?) -> Void) {
        guard NFCNDEFReaderSession.readingAvailable else {
            DispatchQueue.main.async {
                self.writeError = "NFC không khả dụng trên thiết bị này"
                completion(false, "NFC không khả dụng")
            }
            return
        }

        guard URL(string: url) != nil else {
            DispatchQueue.main.async {
                self.writeError = "URL không hợp lệ"
                completion(false, "URL không hợp lệ")
            }
            return
        }

        self.urlToWrite = url
        onWriteComplete = completion
        isWriting = true
        writeError = nil

        readerSession = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: false)
        readerSession?.alertMessage = "Đưa iPhone gần thẻ NFC để ghi"
        readerSession?.begin()
    }

    func stopWriting() {
        readerSession?.invalidate()
        readerSession = nil
        isWriting = false
    }
}

// MARK: - NFCNDEFReaderSessionDelegate
extension NFCService: NFCNDEFReaderSessionDelegate {

    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        DispatchQueue.main.async {
            let wasWriting = self.isWriting

            self.isReading = false
            self.isWriting = false

            if let nfcError = error as? NFCReaderError {
                if nfcError.code == .readerSessionInvalidationErrorUserCanceled {
                    // User canceled, not an error
                    self.readError = nil
                    self.writeError = nil
                } else {
                    if wasWriting {
                        self.writeError = nfcError.localizedDescription
                        self.onWriteComplete?(false, nfcError.localizedDescription)
                    } else {
                        self.readError = nfcError.localizedDescription
                    }
                }
            } else {
                if wasWriting {
                    self.writeError = error.localizedDescription
                    self.onWriteComplete?(false, error.localizedDescription)
                } else {
                    self.readError = error.localizedDescription
                }
            }

            self.onReadComplete?(nil)
            self.onReadComplete = nil
            self.onWriteComplete = nil
        }
    }

    func readerSessionDidBecomeActive(_ session: NFCNDEFReaderSession) {
        // Called when the NFC reader session becomes active
        // This is when the user can start scanning
        print("NFC Reader Session is now active and ready to scan")
    }

    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        // This method is required by the protocol but we handle reading manually with didDetect tags
        // You can add implementation here if needed for automatic NDEF message handling
    }

    func readerSession(_ session: NFCNDEFReaderSession, didDetect tags: [NFCNDEFTag]) {
        guard let tag = tags.first else {
            session.invalidate(errorMessage: "Không tìm thấy thẻ NFC")
            return
        }

        if isWriting {
            writeToTag(session: session, tag: tag)
        } else if isReading {
            readFromTag(session: session, tag: tag)
        }
    }

    private func readFromTag(session: NFCNDEFReaderSession, tag: NFCNDEFTag) {
        session.connect(to: tag) { error in
            if let error = error {
                session.invalidate(errorMessage: "Không thể kết nối: \(error.localizedDescription)")
                return
            }

            tag.readNDEF { message, error in
                if let error = error {
                    session.invalidate(errorMessage: "Không thể đọc thẻ: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        self.isReading = false
                        self.readError = error.localizedDescription
                        self.onReadComplete?(nil)
                        self.onReadComplete = nil
                    }
                    return
                }

                guard let message = message else {
                    session.invalidate(errorMessage: "Thẻ trống")
                    DispatchQueue.main.async {
                        self.isReading = false
                        self.readError = "Thẻ NFC trống"
                        self.onReadComplete?(nil)
                        self.onReadComplete = nil
                    }
                    return
                }

                // Find URL in NDEF records
                for record in message.records {
                    if let url = record.wellKnownTypeURIPayload() {
                        session.alertMessage = "Đọc thẻ thành công!"
                        session.invalidate()
                        DispatchQueue.main.async {
                            self.lastReadURL = url.absoluteString
                            self.isReading = false
                            self.onReadComplete?(url.absoluteString)
                            self.onReadComplete = nil
                        }
                        return
                    }
                }

                // No URL found
                session.invalidate(errorMessage: "Không tìm thấy URL trong thẻ")
                DispatchQueue.main.async {
                    self.isReading = false
                    self.readError = "Không tìm thấy URL trong thẻ NFC"
                    self.onReadComplete?(nil)
                    self.onReadComplete = nil
                }
            }
        }
    }

    private func writeToTag(session: NFCNDEFReaderSession, tag: NFCNDEFTag) {
        guard let urlString = urlToWrite, let url = URL(string: urlString) else {
            session.invalidate(errorMessage: "URL không hợp lệ")
            return
        }

        session.connect(to: tag) { error in
            if let error = error {
                session.invalidate(errorMessage: error.localizedDescription)
                return
            }

            tag.queryNDEFStatus { status, capacity, error in
                if let error = error {
                    session.invalidate(errorMessage: error.localizedDescription)
                    return
                }

                switch status {
                case .notSupported:
                    session.invalidate(errorMessage: "Thẻ NFC không hỗ trợ NDEF")
                case .readOnly:
                    session.invalidate(errorMessage: "Thẻ NFC chỉ đọc được")
                case .readWrite:
                    let payload = NFCNDEFPayload.wellKnownTypeURIPayload(url: url)!
                    let message = NFCNDEFMessage(records: [payload])

                    tag.writeNDEF(message) { error in
                        if let error = error {
                            session.invalidate(errorMessage: error.localizedDescription)
                            DispatchQueue.main.async {
                                self.isWriting = false
                                self.writeError = error.localizedDescription
                                self.onWriteComplete?(false, error.localizedDescription)
                                self.onWriteComplete = nil
                            }
                        } else {
                            session.alertMessage = "Đã ghi thành công!"
                            DispatchQueue.main.async {
                                self.isWriting = false
                                self.onWriteComplete?(true, nil)
                                self.onWriteComplete = nil
                            }
                            session.invalidate()
                        }
                    }
                @unknown default:
                    session.invalidate(errorMessage: "Trạng thái thẻ không xác định")
                }
            }
        }
    }
}
