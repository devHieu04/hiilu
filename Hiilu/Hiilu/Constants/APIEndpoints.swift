//
//  APIEndpoints.swift
//  Hiilu
//
//  Created on 30/11/25.
//

import Foundation

struct APIEndpoints {
    // Base URL
    static let baseURL = "http://localhost:8080/api/v1"

    // Auth endpoints
    struct Auth {
        static let register = "/auth/register"
        static let login = "/auth/login"
        static let logout = "/auth/logout"
        static let me = "/auth/me"
        static let updateProfile = "/auth/profile"
        static let changePassword = "/auth/change-password"
        static let loginHistory = "/auth/login-history"
    }

    // Cards endpoints
    struct Cards {
        static let list = "/cards"
        static let create = "/cards"
        static func get(id: String) -> String { "/cards/\(id)" }
        static func update(id: String) -> String { "/cards/\(id)" }
        static func delete(id: String) -> String { "/cards/\(id)" }
        static func share(uuid: String) -> String { "/cards/share/\(uuid)" }
        static func regenerateQR(id: String) -> String { "/cards/\(id)/regenerate-qr" }
    }
}
