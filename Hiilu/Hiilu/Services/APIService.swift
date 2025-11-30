//
//  APIService.swift
//  Hiilu
//
//  Created on 30/11/25.
//

import Foundation
import UIKit

class APIService {
    static let shared = APIService()

    private let baseURL = APIConfig.baseURL
    private var authToken: String?

    private init() {}

    func setAuthToken(_ token: String?) {
        self.authToken = token
    }

    private func request<T: Decodable>(
        endpoint: String,
        method: String = "GET",
        body: Data? = nil
    ) async throws -> T {
        let fullURL = "\(baseURL)\(endpoint)"
        print("🌐 [APIService] Making \(method) request to: \(fullURL)")
        print("   - Base URL: \(baseURL)")
        print("   - Endpoint: \(endpoint)")
        print("   - Has auth token: \(authToken != nil ? "Yes" : "No")")

        guard let url = URL(string: fullURL) else {
            print("❌ [APIService] Invalid URL: \(fullURL)")
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.allHTTPHeaderFields = APIConfig.headers(withToken: authToken)

        if let body = body {
            request.httpBody = body
            if let bodyString = String(data: body, encoding: .utf8) {
                print("📤 [APIService] Request body: \(bodyString)")
            }
        }

        print("📋 [APIService] Headers: \(request.allHTTPHeaderFields ?? [:])")

        do {
            print("⏳ [APIService] Sending request...")
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ [APIService] Invalid response type")
                throw APIError.invalidResponse
            }

            print("📥 [APIService] Response status: \(httpResponse.statusCode)")

            guard (200...299).contains(httpResponse.statusCode) else {
                if let errorData = try? JSONDecoder().decode(APIErrorResponse.self, from: data) {
                    print("❌ [APIService] Server error: \(errorData.message)")
                    throw APIError.serverError(errorData.message)
                }
                print("❌ [APIService] HTTP error: \(httpResponse.statusCode)")
                throw APIError.httpError(httpResponse.statusCode)
            }

            if let responseString = String(data: data, encoding: .utf8) {
                print("📦 [APIService] Response data: \(responseString.prefix(200))...")
            }

            let decoder = JSONDecoder()
            // Try snake_case first, if fails try camelCase
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let decoded = try decoder.decode(T.self, from: data)
                print("✅ [APIService] Successfully decoded response")
                return decoded
            } catch {
                print("⚠️ [APIService] Snake case decode failed, trying camelCase...")
                // If snake_case fails, try without conversion
                let camelDecoder = JSONDecoder()
                let decoded = try camelDecoder.decode(T.self, from: data)
                print("✅ [APIService] Successfully decoded with camelCase")
                return decoded
            }
        } catch {
            if error is APIError {
                throw error
            }
            print("❌ [APIService] Network error: \(error.localizedDescription)")
            throw APIError.networkError(error.localizedDescription)
        }
    }

    // MARK: - Auth

    func register(email: String, name: String, password: String) async throws -> AuthResponse {
        let body = [
            "email": email,
            "name": name,
            "password": password
        ]
        let bodyData = try JSONSerialization.data(withJSONObject: body)
        return try await request(endpoint: APIEndpoints.Auth.register, method: "POST", body: bodyData)
    }

    func login(email: String, password: String) async throws -> AuthResponse {
        let body = [
            "email": email,
            "password": password
        ]
        let bodyData = try JSONSerialization.data(withJSONObject: body)
        return try await request(endpoint: APIEndpoints.Auth.login, method: "POST", body: bodyData)
    }

    func getMe() async throws -> User {
        return try await request(endpoint: APIEndpoints.Auth.me)
    }

    // MARK: - Cards

    func getCards() async throws -> [Card] {
        print("📋 [APIService] Getting cards list...")
        return try await request(endpoint: APIEndpoints.Cards.list)
    }

    func getCard(id: String) async throws -> Card {
        print("📋 [APIService] Getting card: \(id)")
        return try await request(endpoint: APIEndpoints.Cards.get(id: id))
    }

    func getCardByUuid(uuid: String) async throws -> Card {
        return try await request(endpoint: APIEndpoints.Cards.share(uuid: uuid))
    }

    // MARK: - Auth Methods

    func updateProfile(name: String?, email: String?) async throws -> User {
        print("📝 [APIService] Updating profile...")
        print("   - Name: \(name ?? "nil")")
        print("   - Email: \(email ?? "nil")")

        var bodyDict: [String: Any] = [:]
        if let name = name, !name.isEmpty {
            bodyDict["name"] = name
        }
        if let email = email, !email.isEmpty {
            bodyDict["email"] = email
        }

        print("   - Body dict: \(bodyDict)")

        guard let bodyData = try? JSONSerialization.data(withJSONObject: bodyDict) else {
            print("❌ [APIService] Failed to serialize body")
            throw APIError.invalidRequest
        }

        print("   - Endpoint: \(APIEndpoints.Auth.updateProfile)")
        print("   - Method: PATCH")

        return try await request(
            endpoint: APIEndpoints.Auth.updateProfile,
            method: "PATCH",
            body: bodyData
        )
    }

    func changePassword(currentPassword: String, newPassword: String, confirmPassword: String) async throws {
        print("🔒 [APIService] Changing password...")
        print("   - Current password length: \(currentPassword.count)")
        print("   - New password length: \(newPassword.count)")
        print("   - Confirm password length: \(confirmPassword.count)")

        let bodyDict: [String: Any] = [
            "currentPassword": currentPassword,
            "newPassword": newPassword,
            "confirmPassword": confirmPassword
        ]

        guard let bodyData = try? JSONSerialization.data(withJSONObject: bodyDict) else {
            print("❌ [APIService] Failed to serialize body")
            throw APIError.invalidRequest
        }

        print("   - Endpoint: \(APIEndpoints.Auth.changePassword)")
        print("   - Method: POST")

        struct ChangePasswordResponse: Codable {
            let message: String
        }

        let response: ChangePasswordResponse = try await request(
            endpoint: APIEndpoints.Auth.changePassword,
            method: "POST",
            body: bodyData
        )

        print("✅ [APIService] Password changed: \(response.message)")
    }

    func updateCard(
        id: String,
        cardName: String,
        ownerName: String,
        email: String?,
        phoneNumber: String?,
        company: String?,
        address: String?,
        description: String?,
        themeColor: String?,
        links: [Link]?,
        avatarImage: UIImage?,
        coverImage: UIImage?
    ) async throws -> Card {
        print("📝 [APIService] Updating card: \(id)")

        let fullURL = "\(baseURL)\(APIEndpoints.Cards.update(id: id))"
        guard let url = URL(string: fullURL) else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"

        // Create multipart form data
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var headers = APIConfig.headers(withToken: authToken)
        headers.removeValue(forKey: "Content-Type") // Remove JSON content type
        request.allHTTPHeaderFields = headers

        var body = Data()

        // Add text fields
        func appendField(_ name: String, _ value: String) {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }

        appendField("cardName", cardName)
        appendField("ownerName", ownerName)
        if let email = email, !email.isEmpty {
            appendField("email", email)
        }
        if let phoneNumber = phoneNumber, !phoneNumber.isEmpty {
            appendField("phoneNumber", phoneNumber)
        }
        if let company = company, !company.isEmpty {
            appendField("company", company)
        }
        if let address = address, !address.isEmpty {
            appendField("address", address)
        }
        if let description = description, !description.isEmpty {
            appendField("description", description)
        }

        // Add theme
        if let themeColor = themeColor, !themeColor.isEmpty {
            let themeDict: [String: Any?] = ["color": themeColor, "icon": nil]
            if let themeData = try? JSONSerialization.data(withJSONObject: themeDict),
               let themeString = String(data: themeData, encoding: .utf8) {
                appendField("theme", themeString)
            }
        }

        // Add links
        if let links = links, !links.isEmpty {
            if let linksData = try? JSONEncoder().encode(links),
               let linksString = String(data: linksData, encoding: .utf8) {
                appendField("links", linksString)
            }
        }

        // Add avatar image
        if let avatarImage = avatarImage, let imageData = avatarImage.jpegData(compressionQuality: 0.8) {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"avatar\"; filename=\"avatar.jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)
        }

        // Add cover image
        if let coverImage = coverImage, let imageData = coverImage.jpegData(compressionQuality: 0.8) {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"coverImage\"; filename=\"cover.jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)
        }

        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body

        print("📤 [APIService] Sending update request with \(body.count) bytes")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }

            print("📥 [APIService] Response status: \(httpResponse.statusCode)")

            guard (200...299).contains(httpResponse.statusCode) else {
                if let errorData = try? JSONDecoder().decode(APIErrorResponse.self, from: data) {
                    throw APIError.serverError(errorData.message)
                }
                throw APIError.httpError(httpResponse.statusCode)
            }

            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let updatedCard = try decoder.decode(Card.self, from: data)
            print("✅ [APIService] Card updated successfully")
            return updatedCard
        } catch {
            if error is APIError {
                throw error
            }
            throw APIError.networkError(error.localizedDescription)
        }
    }
}

enum APIError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case invalidRequest
    case networkError(String)
    case serverError(String)
    case httpError(Int)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "URL không hợp lệ"
        case .invalidResponse:
            return "Phản hồi không hợp lệ"
        case .invalidRequest:
            return "Yêu cầu không hợp lệ"
        case .networkError(let message):
            return "Lỗi mạng: \(message)"
        case .serverError(let message):
            return message
        case .httpError(let code):
            return "Lỗi HTTP: \(code)"
        }
    }
}

struct APIErrorResponse: Codable {
    let message: String
}
