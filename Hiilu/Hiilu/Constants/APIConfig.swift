//
//  APIConfig.swift
//  Hiilu
//
//  Created on 30/11/25.
//

import Foundation

struct APIConfig {
    // Using ngrok tunnel for development
    //static let baseURL = "https://68bbf5b7c771.ngrok-free.app/api/v1"

    static let baseURL = "http://localhost:8080/api/v1"

    
    // For local development
    // #if targetEnvironment(simulator)
    // static let baseURL = "http://localhost:8080/api/v1"
    // #else
    // static let baseURL = "http://YOUR_MAC_IP:8080/api/v1"
    // #endif

    // For production, change to your production URL
    // static let baseURL = "https://api.hiilu.com/api/v1"

    static var defaultHeaders: [String: String] {
        [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    }

    static func headers(withToken token: String?) -> [String: String] {
        var headers = defaultHeaders
        if let token = token {
            headers["Authorization"] = "Bearer \(token)"
        }
        return headers
    }
}
