//
//  MainTabView.swift
//  Hiilu
//
//  Created on 30/11/25.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            // Home Tab (Cards)
            HomeView()
                .tabItem {
                    Image(systemName: "creditcard.fill")
                    Text("Thẻ")
                }
                .tag(0)

            // Account Tab
            AccountView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Tài khoản")
                }
                .tag(1)

            // Support Tab
            SupportView()
                .tabItem {
                    Image(systemName: "questionmark.circle.fill")
                    Text("Hỗ trợ")
                }
                .tag(2)
        }
        .accentColor(Color(red: 0.43, green: 0.76, blue: 0.96))
    }
}

#Preview {
    MainTabView()
}
