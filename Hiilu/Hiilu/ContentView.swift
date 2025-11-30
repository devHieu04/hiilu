//
//  ContentView.swift
//  Hiilu
//
//  Created by Nguyễn Duy Hiếu on 30/11/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var authManager = AuthManager.shared

    var body: some View {
        Group {
            if authManager.isLoading {
                // Loading screen
                VStack(spacing: 16) {
                    ProgressView()
                    Text("Đang tải...")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
            } else if authManager.isAuthenticated {
                // User is logged in, show Main Tab View
                MainTabView()
            } else {
                // User is not logged in, show Landing Page
                LandingPageView()
            }
        }
        .onAppear {
            print("🏠 [ContentView] App appeared")
            print("   - Is authenticated: \(authManager.isAuthenticated)")
            print("   - User: \(authManager.user?.name ?? "nil")")
            print("   - Token: \(authManager.token != nil ? "exists" : "nil")")
        }
    }
}

#Preview {
    ContentView()
}
