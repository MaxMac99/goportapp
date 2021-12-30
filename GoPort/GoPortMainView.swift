//
//  GoPortMainView.swift
//  GoPort
//
//  Created by Max Vissing on 27.12.21.
//

import SwiftUI

struct GoPortMainView: View {
    @StateObject var serverService = ServerService.preview
    
    var body: some View {
        TabView {
            SettingsView(serverService: serverService)
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
    }
}

struct GoPortMainView_Previews: PreviewProvider {
    static var previews: some View {
        GoPortMainView(serverService: ServerService.preview)
    }
}
