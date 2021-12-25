//
//  GoPortApp.swift
//  GoPort
//
//  Created by Max Vissing on 25.12.21.
//

import SwiftUI

@main
struct GoPortApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
