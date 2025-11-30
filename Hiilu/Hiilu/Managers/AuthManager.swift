//
//  AuthManager.swift
//  Hiilu
//
//  Created on 30/11/25.
//

import Foundation
import Combine

class AuthManager: ObservableObject {
    static let shared = AuthManager()

    @Published var user: User?
    @Published var token: String?
    @Published var isLoading = false

    private let apiService = APIService.shared
    private let tokenKey = "auth_token"

    private init() {
        loadToken()
    }

    // Load token from UserDefaults
    private func loadToken() {
        if let savedToken = UserDefaults.standard.string(forKey: tokenKey) {
            Task { @MainActor in
                self.token = savedToken
                apiService.setAuthToken(savedToken)
                await loadUser()
            }
        } else {
            Task { @MainActor in
                self.isLoading = false
            }
        }
    }

    // Load user info
    func loadUser() async {
        print("👤 [AuthManager] Loading user info...")

        await MainActor.run {
            self.isLoading = true
        }

        do {
            print("📡 [AuthManager] Calling API getMe endpoint...")
            let user = try await apiService.getMe()
            print("✅ [AuthManager] User loaded successfully!")
            print("   - User ID: \(user.id)")
            print("   - User Name: \(user.name)")
            print("   - User Email: \(user.email)")

            await MainActor.run {
                self.user = user
                self.isLoading = false
            }
        } catch {
            print("❌ [AuthManager] Failed to load user: \(error.localizedDescription)")
            await MainActor.run {
                self.token = nil
                self.user = nil
                self.isLoading = false
                UserDefaults.standard.removeObject(forKey: tokenKey)
                print("🗑️ [AuthManager] Token cleared due to error")
            }
        }
    }

    // Login
    func login(email: String, password: String) async throws {
        print("🔐 [AuthManager] Starting login for email: \(email)")

        await MainActor.run {
            self.isLoading = true
        }

        do {
            print("📡 [AuthManager] Calling API login endpoint...")
            let response = try await apiService.login(email: email, password: password)
            print("✅ [AuthManager] Login successful!")
            print("   - User ID: \(response.user.id)")
            print("   - User Name: \(response.user.name)")
            print("   - User Email: \(response.user.email)")
            print("   - Token received: \(response.token.prefix(20))...")

            await MainActor.run {
                self.token = response.token
                self.user = response.user
                self.isLoading = false
                UserDefaults.standard.set(response.token, forKey: tokenKey)
                apiService.setAuthToken(response.token)
                print("💾 [AuthManager] Token saved to UserDefaults")
                print("✅ [AuthManager] Login completed successfully!")
            }
        } catch {
            print("❌ [AuthManager] Login failed with error: \(error.localizedDescription)")
            if let apiError = error as? APIError {
                print("   - API Error: \(apiError.localizedDescription)")
            }
            await MainActor.run {
                self.isLoading = false
            }
            throw error
        }
    }

    // Register
    func register(email: String, name: String, password: String) async throws {
        print("📝 [AuthManager] Starting register for email: \(email), name: \(name)")

        await MainActor.run {
            self.isLoading = true
        }

        do {
            print("📡 [AuthManager] Calling API register endpoint...")
            let response = try await apiService.register(email: email, name: name, password: password)
            print("✅ [AuthManager] Register successful!")
            print("   - User ID: \(response.user.id)")
            print("   - User Name: \(response.user.name)")
            print("   - User Email: \(response.user.email)")
            print("   - Token received: \(response.token.prefix(20))...")

            await MainActor.run {
                self.token = response.token
                self.user = response.user
                self.isLoading = false
                UserDefaults.standard.set(response.token, forKey: tokenKey)
                apiService.setAuthToken(response.token)
                print("💾 [AuthManager] Token saved to UserDefaults")
                print("✅ [AuthManager] Register completed successfully!")
            }
        } catch {
            print("❌ [AuthManager] Register failed with error: \(error.localizedDescription)")
            if let apiError = error as? APIError {
                print("   - API Error: \(apiError.localizedDescription)")
            }
            await MainActor.run {
                self.isLoading = false
            }
            throw error
        }
    }

    // Logout
    func logout() {
        token = nil
        user = nil
        UserDefaults.standard.removeObject(forKey: tokenKey)
        apiService.setAuthToken(nil)
    }

    // Check if user is authenticated
    var isAuthenticated: Bool {
        return token != nil && user != nil
    }
}
