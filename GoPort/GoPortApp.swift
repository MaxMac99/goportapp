//
//  GoPortApp.swift
//  GoPort
//
//  Created by Max Vissing on 25.12.21.
//

import SwiftUI

@main
struct GoPortApp: App {
    @StateObject private var serverService = ServerService.shared

    var body: some Scene {
        WindowGroup {
            GoPortMainView()
                .environmentObject(serverService)
        }
    }
}
