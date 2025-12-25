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

        readerSession = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: true)
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
            self.isReading = false
            self.isWriting = false

            if let nfcError = error as? NFCReaderError {
                switch nfcError.code {
                case .readerSessionInvalidationErrorUserCanceled:
                    // User canceled, not an error
                    self.readError = nil
                    self.writeError = nil
                    self.onWriteComplete?(false, nil)
                default:
                    if self.isWriting {
                        self.writeError = nfcError.localizedDescription
                        self.onWriteComplete?(false, nfcError.localizedDescription)
                    } else {
                        self.readError = nfcError.localizedDescription
                    }
                }
            } else {
                if self.isWriting {
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

    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        // This is called for reading operations only
        for message in messages {
            for record in message.records {
                if let url = record.wellKnownTypeURIPayload() {
                    DispatchQueue.main.async {
                        self.lastReadURL = url.absoluteString
                        self.isReading = false
                        self.onReadComplete?(url.absoluteString)
                        self.onReadComplete = nil
                    }
                    session.invalidate()
                    return
                }
            }
        }

        DispatchQueue.main.async {
            self.isReading = false
            self.readError = "Không tìm thấy URL trong thẻ NFC"
            self.onReadComplete?(nil)
            self.onReadComplete = nil
        }
        session.invalidate()
    }

    func readerSession(_ session: NFCNDEFReaderSession, didDetect tags: [NFCNDEFTag]) {
        // This is called for writing operations
        guard let tag = tags.first else {
            session.invalidate(errorMessage: "Không tìm thấy thẻ NFC")
            return
        }

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
