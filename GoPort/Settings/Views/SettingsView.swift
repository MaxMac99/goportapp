//
//  SettingsView.swift
//  GoPort
//
//  Created by Max Vissing on 25.12.21.
//

import SwiftUI

struct SettingsView: View {
    @StateObject var serverService = ServerService()
    
    var body: some View {
        NavigationView {
            List {
                Section("Servers") {
                    ForEach(serverService.servers, id: \.name) { server in
                        ServerRowView(server: server)
                    }
                    .onDelete { offsets in
                        serverService.removeServer(at: offsets)
                    }
                }
            }
            .toolbar {
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
    
    func addItem() {
        // TODO: Open view to add servers
    }
}

#if DEBUG
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(serverService: ServerService.preview)
    }
}
#endif
