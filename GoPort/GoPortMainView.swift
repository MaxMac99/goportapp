//
//  GoPortMainView.swift
//  GoPort
//
//  Created by Max Vissing on 27.12.21.
//

import SwiftUI

struct GoPortMainView: View {
    @EnvironmentObject var serverService: ServerService
    
    var body: some View {
        TabView {
            ProjectListView()
                .tabItem {
                    Image(systemName: "books.vertical")
                    Text("Compose")
                }
            ContainerListView()
                .tabItem {
                    Image(systemName: "shippingbox")
                    Text("Containers")
                }
            ImagesListView()
                .tabItem {
                    Image(systemName: "internaldrive")
                    Text("Images")
                }
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
    }
}

struct GoPortMainView_Previews: PreviewProvider {
    static var previews: some View {
        GoPortMainView()
            .environmentObject(ServerService.preview)
    }
}
