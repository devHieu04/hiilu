//
//  HiiluApp.swift
//  Hiilu
//
//  Created by Nguyễn Duy Hiếu on 30/11/25.
//

import SwiftUI

@main
struct HiiluApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
