//
//  Card.swift
//  Hiilu
//
//  Created on 30/11/25.
//

import Foundation

struct Card: Codable, Identifiable {
    let id: String
    let userId: String
    let cardName: String
    let ownerName: String
    let email: String?
    let phoneNumber: String?
    let company: String?
    let address: String?
    let description: String?
    let avatarUrl: String?
    let coverImageUrl: String?
    let theme: Theme?
    let links: [Link]?
    let qrCodeUrl: String?
    let shareUuid: String?
    let isActive: Bool
    let viewCount: Int
    let createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case userId
        case cardName
        case ownerName
        case email
        case phoneNumber
        case company
        case address
        case description
        case avatarUrl
        case coverImageUrl
        case theme
        case links
        case qrCodeUrl
        case shareUuid
        case isActive
        case viewCount
        case createdAt
        case updatedAt
    }
}

struct Theme: Codable {
    let color: String?
    let icon: String?
}

struct Link: Codable {
    let title: String
    let url: String
    let icon: String?
}
