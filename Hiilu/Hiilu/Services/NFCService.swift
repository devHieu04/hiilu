//
//  NFCService.swift
//  Hiilu
//
//  Rebuilt based on Thelaixedanang implementation  
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
    @Published var statusMessage: String = "Sẵn sàng"

    private var tagSession: NFCTagReaderSession?
    private var urlToWrite: String?
    private var onReadComplete: ((String?) -> Void)?
    private var onWriteComplete: ((Bool, String?) -> Void)?
    private var isWriteMode = false

    private override init() {
        super.init()
    }

    // MARK: - Read NFC Tag
    func startReading(completion: @escaping (String?) -> Void) {
        guard NFCTagReaderSession.readingAvailable else {
            DispatchQueue.main.async {
                self.readError = "NFC không khả dụng trên thiết bị này"
                completion(nil)
            }
            return
        }

        onReadComplete = completion
        isReading = true
        isWriting = false
        isWriteMode = false
        readError = nil
        statusMessage = "Đang quét..."

        print("🎯 Starting NFC Read Session (NFCTagReaderSession)")

        // Use NFCTagReaderSession with both ISO14443 and ISO15693 for maximum compatibility
        tagSession = NFCTagReaderSession(pollingOption: [.iso14443, .iso15693], delegate: self)
        tagSession?.alertMessage = "Đưa iPhone gần thẻ NFC để đọc"
        tagSession?.begin()
    }

    func stopReading() {
        tagSession?.invalidate()
        tagSession = nil
        isReading = false
    }

    // MARK: - Write NFC Tag
    func startWriting(url: String, completion: @escaping (Bool, String?) -> Void) {
        guard NFCTagReaderSession.readingAvailable else {
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
        isReading = false
        isWriteMode = true
        writeError = nil
        statusMessage = "Đang quét..."

        print("🎯 Starting NFC Write Session (NFCTagReaderSession)")
        print("💾 URL to write: \(url)")

        tagSession = NFCTagReaderSession(pollingOption: [.iso14443, .iso15693], delegate: self)
        tagSession?.alertMessage = "Đưa iPhone gần thẻ NFC để ghi"
        tagSession?.begin()
    }

    func stopWriting() {
        tagSession?.invalidate()
        tagSession = nil
        isWriting = false
    }
}

// MARK: - NFCTagReaderSessionDelegate
extension NFCService: NFCTagReaderSessionDelegate {

    func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
        print("✅ NFC Tag Reader Session is now active and ready to scan")
        DispatchQueue.main.async {
            self.statusMessage = "Sẵn sàng quét thẻ..."
        }
    }

    func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
        DispatchQueue.main.async {
            let wasWriting = self.isWriteMode
            self.isReading = false
            self.isWriting = false

            if let readerError = error as? NFCReaderError {
                switch readerError.code {
                case .readerSessionInvalidationErrorUserCanceled:
                    self.statusMessage = "Đã hủy quét"
                    self.readError = nil
                    self.writeError = nil
                default:
                    self.statusMessage = "Lỗi: \(error.localizedDescription)"
                    if wasWriting {
                        self.writeError = error.localizedDescription
                        self.onWriteComplete?(false, error.localizedDescription)
                    } else {
                        self.readError = error.localizedDescription
                    }
                }
            }

            self.onReadComplete?(nil)
            self.onReadComplete = nil
            self.onWriteComplete = nil
            self.tagSession = nil
        }
    }

    func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        print("\n========================================")
        print("🏷️ NFC Tag detected!")
        print("========================================")
        print("📊 Mode - isReading: \(isReading), isWriting: \(isWriting)")
        print("🏷️ Total tags: \(tags.count)")

        guard let tag = tags.first else {
            print("❌ No tag in array")
            session.invalidate(errorMessage: "Không tìm thấy thẻ NFC")
            return
        }

        // Print tag type for debugging
        switch tag {
        case .miFare:
            print("🏷️ Tag type: MiFare (NTAG/Ultralight)")
        case .iso15693:
            print("🏷️ Tag type: ISO15693")
        case .iso7816:
            print("🏷️ Tag type: ISO7816")
        case .feliCa:
            print("🏷️ Tag type: FeliCa")
        @unknown default:
            print("🏷️ Tag type: Unknown")
        }

        // Support both MiFare and ISO15693 tags
        session.connect(to: tag) { error in
            if let error = error {
                print("❌ Connection error: \(error.localizedDescription)")
                session.invalidate(errorMessage: "Lỗi kết nối: \(error.localizedDescription)")
                return
            }

            print("✅ Connected to tag successfully")

            // Handle different tag types
            switch tag {
            case .miFare(let miFareTag):
                print("✅ MiFare tag detected")
                print("🆔 Tag identifier: \(miFareTag.identifier.map { String(format: "%02x", $0) }.joined())")

                if self.isWriteMode {
                    self.writeToMiFareTag(session: session, tag: miFareTag)
                } else {
                    self.readFromMiFareTag(session: session, tag: miFareTag)
                }

            case .iso15693(let iso15693Tag):
                print("✅ ISO15693 tag detected")
                print("🆔 Tag identifier: \(iso15693Tag.identifier.map { String(format: "%02x", $0) }.joined())")

                if self.isWriteMode {
                    self.writeToISO15693Tag(session: session, tag: iso15693Tag)
                } else {
                    self.readFromISO15693Tag(session: session, tag: iso15693Tag)
                }

            default:
                print("❌ Unsupported tag type")
                session.invalidate(errorMessage: "Loại thẻ không được hỗ trợ")
            }
        }
    }

    // MARK: - Read from MiFare Tag

    private func readFromMiFareTag(session: NFCTagReaderSession, tag: NFCMiFareTag) {
        print("📖 Reading NDEF data from MiFare tag...")

        // Query NDEF status
        tag.queryNDEFStatus { status, capacity, error in
            if let error = error {
                print("❌ Query NDEF status error: \(error.localizedDescription)")
                session.invalidate(errorMessage: "Không thể đọc thẻ: \(error.localizedDescription)")
                return
            }

            print("📊 NDEF Status: \(status.rawValue), Capacity: \(capacity) bytes")

            // Read NDEF message
            tag.readNDEF { message, error in
                if let error = error {
                    print("❌ Read NDEF error: \(error.localizedDescription)")
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
                    print("⚠️ Tag is blank/empty")
                    session.invalidate(errorMessage: "Thẻ trống")
                    DispatchQueue.main.async {
                        self.isReading = false
                        self.readError = "Thẻ NFC trống"
                        self.onReadComplete?(nil)
                        self.onReadComplete = nil
                    }
                    return
                }

                print("📦 NDEF Message found with \(message.records.count) records")

                // Extract URL from NDEF records
                for (index, record) in message.records.enumerated() {
                    print("\n--- Record \(index + 1) ---")
                    print("  Type: \(String(data: record.type, encoding: .utf8) ?? "N/A")")
                    print("  Payload length: \(record.payload.count) bytes")

                    if let url = record.wellKnownTypeURIPayload() {
                        print("✅ URL found: \(url.absoluteString)")
                        session.alertMessage = "Đọc thẻ thành công!"
                        session.invalidate()
                        DispatchQueue.main.async {
                            self.lastReadURL = url.absoluteString
                            self.isReading = false
                            self.statusMessage = "Đọc thành công: \(url.absoluteString)"
                            self.onReadComplete?(url.absoluteString)
                            self.onReadComplete = nil
                        }
                        return
                    }
                }

                // No URL found
                print("❌ No URL record found in NDEF message")
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

    // MARK: - Write to MiFare Tag

    private func writeToMiFareTag(session: NFCTagReaderSession, tag: NFCMiFareTag) {
        guard let urlString = urlToWrite, let url = URL(string: urlString) else {
            session.invalidate(errorMessage: "URL không hợp lệ")
            return
        }

        print("✍️ Writing URL to MiFare tag: \(urlString)")

        // Query NDEF status first
        tag.queryNDEFStatus { status, capacity, error in
            if let error = error {
                print("❌ Query NDEF status error: \(error.localizedDescription)")
                session.invalidate(errorMessage: error.localizedDescription)
                return
            }

            print("📊 NDEF Status: \(status.rawValue), Capacity: \(capacity) bytes")

            switch status {
            case .notSupported:
                print("❌ Tag does not support NDEF")
                session.invalidate(errorMessage: "Thẻ NFC không hỗ trợ NDEF")

            case .readOnly:
                print("❌ Tag is read-only")
                session.invalidate(errorMessage: "Thẻ NFC chỉ đọc được")

            case .readWrite:
                print("✅ Tag is read-write, proceeding with write...")

                // Create NDEF payload
                guard let payload = NFCNDEFPayload.wellKnownTypeURIPayload(url: url) else {
                    print("❌ Failed to create NDEF payload")
                    session.invalidate(errorMessage: "Không thể tạo dữ liệu NDEF")
                    return
                }

                let message = NFCNDEFMessage(records: [payload])
                print("📝 NDEF message created with \(message.records.count) record(s)")

                // Write NDEF message
                tag.writeNDEF(message) { error in
                    if let error = error {
                        print("❌ Write NDEF error: \(error.localizedDescription)")
                        session.invalidate(errorMessage: error.localizedDescription)
                        DispatchQueue.main.async {
                            self.isWriting = false
                            self.writeError = error.localizedDescription
                            self.statusMessage = "Lỗi ghi: \(error.localizedDescription)"
                            self.onWriteComplete?(false, error.localizedDescription)
                            self.onWriteComplete = nil
                        }
                    } else {
                        print("✅ Write successful!")
                        session.alertMessage = "Đã ghi thành công!"
                        session.invalidate()
                        DispatchQueue.main.async {
                            self.isWriting = false
                            self.statusMessage = "Ghi thẻ thành công!"
                            self.onWriteComplete?(true, nil)
                            self.onWriteComplete = nil
                        }
                    }
                }

            @unknown default:
                print("❌ Unknown NDEF status")
                session.invalidate(errorMessage: "Trạng thái thẻ không xác định")
            }
        }
    }

    // MARK: - Read from ISO15693 Tag

    private func readFromISO15693Tag(session: NFCTagReaderSession, tag: NFCISO15693Tag) {
        print("📖 Reading data from ISO15693 tag...")

        // Query NDEF status to determine read method
        tag.queryNDEFStatus { status, capacity, error in
            if let error = error {
                print("⚠️ NDEF query error, will use block-level read: \(error.localizedDescription)")
                self.readFromISO15693TagBlockLevel(session: session, tag: tag)
                return
            }

            print("📊 NDEF Status: \(status.rawValue), Capacity: \(capacity) bytes")

            switch status {
            case .notSupported:
                print("⚠️ Tag does not support NDEF, using block-level read")
                self.readFromISO15693TagBlockLevel(session: session, tag: tag)

            case .readOnly, .readWrite:
                print("✅ Tag supports NDEF, using NDEF read...")
                self.readFromISO15693TagNDEF(session: session, tag: tag)

            @unknown default:
                print("❌ Unknown NDEF status")
                session.invalidate(errorMessage: "Trạng thái thẻ không xác định")
            }
        }
    }

    // NDEF-based read for ISO15693
    private func readFromISO15693TagNDEF(session: NFCTagReaderSession, tag: NFCISO15693Tag) {
        tag.readNDEF { message, error in
            if let error = error {
                print("❌ Read NDEF error: \(error.localizedDescription)")
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
                print("⚠️ Tag is blank/empty")
                session.invalidate(errorMessage: "Thẻ trống")
                DispatchQueue.main.async {
                    self.isReading = false
                    self.readError = "Thẻ NFC trống"
                    self.onReadComplete?(nil)
                    self.onReadComplete = nil
                }
                return
            }

            print("📦 NDEF Message found with \(message.records.count) records")

            // Extract URL from NDEF records
            for (index, record) in message.records.enumerated() {
                print("\n--- Record \(index + 1) ---")
                print("  Type: \(String(data: record.type, encoding: .utf8) ?? "N/A")")
                print("  Payload length: \(record.payload.count) bytes")

                if let url = record.wellKnownTypeURIPayload() {
                    print("✅ URL found: \(url.absoluteString)")
                    session.alertMessage = "Đọc thẻ thành công!"
                    session.invalidate()
                    DispatchQueue.main.async {
                        self.lastReadURL = url.absoluteString
                        self.isReading = false
                        self.statusMessage = "Đọc thành công: \(url.absoluteString)"
                        self.onReadComplete?(url.absoluteString)
                        self.onReadComplete = nil
                    }
                    return
                }
            }

            // No URL found
            print("❌ No URL record found in NDEF message")
            session.invalidate(errorMessage: "Không tìm thấy URL trong thẻ")
            DispatchQueue.main.async {
                self.isReading = false
                self.readError = "Không tìm thấy URL trong thẻ NFC"
                self.onReadComplete?(nil)
                self.onReadComplete = nil
            }
        }
    }

    // Block-level read for ISO15693 tags that don't support NDEF
    private func readFromISO15693TagBlockLevel(session: NFCTagReaderSession, tag: NFCISO15693Tag) {
        print("📖 Using block-level read")

        // First, read header blocks to get URL length
        let blockSize = 4
        var readData = Data()
        let dispatchGroup = DispatchGroup()
        var headerReadSuccess = true

        // Read first 2 blocks (8 bytes) to get magic header + URL length
        for i in 0..<2 {
            dispatchGroup.enter()
            tag.readSingleBlock(requestFlags: [.highDataRate], blockNumber: UInt8(i)) { data, error in
                defer { dispatchGroup.leave() }
                if let error = error {
                    print("  ❌ Block \(i) read error: \(error.localizedDescription)")
                    headerReadSuccess = false
                    return
                }
                readData.append(data)
                print("  ✅ Block \(i) read: \(data.map { String(format: "%02x", $0) }.joined())")
            }
        }

        dispatchGroup.notify(queue: .main) {
            if !headerReadSuccess {
                print("❌ Failed to read header blocks")
                session.invalidate(errorMessage: "Lỗi khi đọc thẻ")
                DispatchQueue.main.async {
                    self.isReading = false
                    self.readError = "Lỗi khi đọc thẻ"
                    self.onReadComplete?(nil)
                    self.onReadComplete = nil
                }
                return
            }

            // Check magic header
            guard readData.count >= 6 else {
                print("❌ Not enough header data")
                session.invalidate(errorMessage: "Dữ liệu không đủ")
                DispatchQueue.main.async {
                    self.isReading = false
                    self.readError = "Dữ liệu không đủ"
                    self.onReadComplete?(nil)
                    self.onReadComplete = nil
                }
                return
            }

            let magicHeader = readData.prefix(4)
            guard let magicString = String(data: magicHeader, encoding: .utf8), magicString == "HILU" else {
                print("❌ Invalid magic header: \(magicHeader.map { String(format: "%02x", $0) }.joined())")
                session.invalidate(errorMessage: "Thẻ trống hoặc dữ liệu không hợp lệ")
                DispatchQueue.main.async {
                    self.isReading = false
                    self.readError = "Thẻ trống hoặc dữ liệu không hợp lệ"
                    self.onReadComplete?(nil)
                    self.onReadComplete = nil
                }
                return
            }

            // Read URL length
            let urlLengthBytes = readData[4..<6]
            let urlLength = Int(UInt16(urlLengthBytes[urlLengthBytes.startIndex]) << 8 | UInt16(urlLengthBytes[urlLengthBytes.startIndex + 1]))
            print("📏 URL length: \(urlLength) bytes")

            // Calculate how many more blocks we need
            let totalBytesNeeded = 6 + urlLength  // header (4) + length (2) + URL
            let totalBlocksNeeded = (totalBytesNeeded + blockSize - 1) / blockSize
            let blocksAlreadyRead = 2
            let blocksToRead = totalBlocksNeeded - blocksAlreadyRead

            print("📦 Need \(totalBlocksNeeded) blocks total, already have \(blocksAlreadyRead), reading \(blocksToRead) more")

            if blocksToRead <= 0 {
                // We already have all the data
                self.parseAndReturnURL(from: readData, urlLength: urlLength, session: session)
                return
            }

            // Read remaining blocks
            let dataGroup = DispatchGroup()
            var dataReadSuccess = true

            for i in blocksAlreadyRead..<totalBlocksNeeded {
                dataGroup.enter()
                tag.readSingleBlock(requestFlags: [.highDataRate], blockNumber: UInt8(i)) { data, error in
                    defer { dataGroup.leave() }
                    if let error = error {
                        print("  ❌ Block \(i) read error: \(error.localizedDescription)")
                        dataReadSuccess = false
                        return
                    }
                    readData.append(data)
                    print("  ✅ Block \(i) read: \(data.map { String(format: "%02x", $0) }.joined())")
                }
            }

            dataGroup.notify(queue: .main) {
                if !dataReadSuccess {
                    print("❌ Failed to read data blocks")
                    session.invalidate(errorMessage: "Lỗi khi đọc thẻ")
                    DispatchQueue.main.async {
                        self.isReading = false
                        self.readError = "Lỗi khi đọc thẻ"
                        self.onReadComplete?(nil)
                        self.onReadComplete = nil
                    }
                    return
                }

                self.parseAndReturnURL(from: readData, urlLength: urlLength, session: session)
            }
        }
    }

    private func parseAndReturnURL(from readData: Data, urlLength: Int, session: NFCTagReaderSession) {
        print("📦 Read \(readData.count) bytes total")

        guard readData.count >= 6 + urlLength else {
            print("❌ Data truncated, expected \(6 + urlLength) bytes, got \(readData.count)")
            session.invalidate(errorMessage: "Dữ liệu không đầy đủ")
            DispatchQueue.main.async {
                self.isReading = false
                self.readError = "Dữ liệu không đầy đủ"
                self.onReadComplete?(nil)
                self.onReadComplete = nil
            }
            return
        }

        // Extract URL
        let urlData = readData[6..<(6 + urlLength)]
        guard let url = String(data: urlData, encoding: .utf8) else {
            print("❌ Failed to decode URL")
            session.invalidate(errorMessage: "Không thể đọc URL")
            DispatchQueue.main.async {
                self.isReading = false
                self.readError = "Không thể đọc URL"
                self.onReadComplete?(nil)
                self.onReadComplete = nil
            }
            return
        }

        print("✅ URL found: \(url)")
        session.alertMessage = "Đọc thẻ thành công!"
        session.invalidate()
        DispatchQueue.main.async {
            self.lastReadURL = url
            self.isReading = false
            self.statusMessage = "Đọc thành công: \(url)"
            self.onReadComplete?(url)
            self.onReadComplete = nil
        }
    }

    // MARK: - Write to ISO15693 Tag

    private func writeToISO15693Tag(session: NFCTagReaderSession, tag: NFCISO15693Tag) {
        guard let urlString = urlToWrite, let url = URL(string: urlString) else {
            session.invalidate(errorMessage: "URL không hợp lệ")
            return
        }

        print("✍️ Writing URL to ISO15693 tag: \(urlString)")

        // Query NDEF status first
        tag.queryNDEFStatus { status, capacity, error in
            if let error = error {
                print("⚠️ NDEF query error, will use block-level write: \(error.localizedDescription)")
                self.writeToISO15693TagBlockLevel(session: session, tag: tag, url: urlString)
                return
            }

            print("📊 NDEF Status: \(status.rawValue), Capacity: \(capacity) bytes")

            switch status {
            case .notSupported:
                print("⚠️ Tag does not support NDEF, using block-level write")
                self.writeToISO15693TagBlockLevel(session: session, tag: tag, url: urlString)

            case .readOnly:
                print("❌ Tag is read-only")
                session.invalidate(errorMessage: "Thẻ NFC chỉ đọc được")

            case .readWrite:
                print("✅ Tag supports NDEF, using NDEF write...")
                self.writeToISO15693TagNDEF(session: session, tag: tag, url: url)

            @unknown default:
                print("❌ Unknown NDEF status")
                session.invalidate(errorMessage: "Trạng thái thẻ không xác định")
            }
        }
    }

    // NDEF-based write for ISO15693
    private func writeToISO15693TagNDEF(session: NFCTagReaderSession, tag: NFCISO15693Tag, url: URL) {
        guard let payload = NFCNDEFPayload.wellKnownTypeURIPayload(url: url) else {
            print("❌ Failed to create NDEF payload")
            session.invalidate(errorMessage: "Không thể tạo dữ liệu NDEF")
            return
        }

        let message = NFCNDEFMessage(records: [payload])
        print("📝 NDEF message created with \(message.records.count) record(s)")

        tag.writeNDEF(message) { error in
            if let error = error {
                print("❌ Write NDEF error: \(error.localizedDescription)")
                session.invalidate(errorMessage: error.localizedDescription)
                DispatchQueue.main.async {
                    self.isWriting = false
                    self.writeError = error.localizedDescription
                    self.statusMessage = "Lỗi ghi: \(error.localizedDescription)"
                    self.onWriteComplete?(false, error.localizedDescription)
                    self.onWriteComplete = nil
                }
            } else {
                print("✅ Write successful!")
                session.alertMessage = "Đã ghi thành công!"
                session.invalidate()
                DispatchQueue.main.async {
                    self.isWriting = false
                    self.statusMessage = "Ghi thẻ thành công!"
                    self.onWriteComplete?(true, nil)
                    self.onWriteComplete = nil
                }
            }
        }
    }

    // Block-level write for ISO15693 tags that don't support NDEF
    private func writeToISO15693TagBlockLevel(session: NFCTagReaderSession, tag: NFCISO15693Tag, url: String) {
        print("📝 Using block-level write for URL: \(url)")

        // Prepare data: Magic header "HILU" + URL length (2 bytes) + URL
        var writeData = Data()
        writeData.append("HILU".data(using: .utf8)!) // 4 bytes magic header

        guard let urlData = url.data(using: .utf8) else {
            session.invalidate(errorMessage: "Không thể chuyển đổi URL")
            return
        }

        // Add URL length (2 bytes, big-endian)
        let urlLength = UInt16(urlData.count)
        writeData.append(contentsOf: [UInt8(urlLength >> 8), UInt8(urlLength & 0xFF)])

        // Add URL data
        writeData.append(urlData)

        print("📊 Total data size: \(writeData.count) bytes")

        // ISO15693 block size is typically 4 bytes
        let blockSize = 4
        let blocksNeeded = (writeData.count + blockSize - 1) / blockSize
        print("📦 Writing \(blocksNeeded) blocks")

        let dispatchGroup = DispatchGroup()
        var writeSuccess = true
        var blockErrors: [Int: String] = [:]

        for i in 0..<blocksNeeded {
            let startIndex = i * blockSize
            let endIndex = min(startIndex + blockSize, writeData.count)
            var blockData = writeData[startIndex..<endIndex]

            // Pad block if needed
            if blockData.count < blockSize {
                blockData.append(Data(repeating: 0x00, count: blockSize - blockData.count))
            }

            dispatchGroup.enter()
            let blockNumber = UInt8(i)

            print("  Writing block \(i): \(blockData.map { String(format: "%02x", $0) }.joined())")

            tag.writeSingleBlock(requestFlags: [.highDataRate], blockNumber: blockNumber, dataBlock: blockData) { error in
                defer { dispatchGroup.leave() }
                if let error = error {
                    print("  ❌ Block \(i) write error: \(error.localizedDescription)")
                    writeSuccess = false
                    blockErrors[i] = error.localizedDescription
                } else {
                    print("  ✅ Block \(i) written successfully")
                }
            }
        }

        dispatchGroup.notify(queue: .main) {
            if writeSuccess {
                print("✅ All blocks written successfully!")
                session.alertMessage = "Đã ghi thành công!"
                session.invalidate()
                DispatchQueue.main.async {
                    self.isWriting = false
                    self.statusMessage = "Ghi thẻ thành công!"
                    self.onWriteComplete?(true, nil)
                    self.onWriteComplete = nil
                }
            } else {
                let errorMsg = "Lỗi ghi block: \(blockErrors.values.first ?? "Unknown")"
                print("❌ Write failed: \(errorMsg)")
                session.invalidate(errorMessage: errorMsg)
                DispatchQueue.main.async {
                    self.isWriting = false
                    self.writeError = errorMsg
                    self.statusMessage = "Lỗi ghi: \(errorMsg)"
                    self.onWriteComplete?(false, errorMsg)
                    self.onWriteComplete = nil
                }
            }
        }
    }
}
