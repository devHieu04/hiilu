//
//  User.swift
//  Hiilu
//
//  Created on 30/11/25.
//

import Foundation

struct User: Codable {
    let id: String
    let email: String
    let name: String
    let role: String
    let isActive: Bool
    let createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case email
        case name
        case role
        case isActive
        case createdAt
        case updatedAt
    }
}

struct AuthResponse: Codable {
    let user: User
    let token: String
}
