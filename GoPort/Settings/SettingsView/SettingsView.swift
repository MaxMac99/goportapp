//
//  SettingsView.swift
//  GoPort
//
//  Created by Max Vissing on 25.12.21.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var serverService: ServerService
    @StateObject var viewModel = SettingsViewModel()
    
    var body: some View {
        NavigationView {
            List {
                Section("Servers") {
                    ForEach(serverService.servers) { server in
                        ServerRowView(server: server, status: viewModel.serverStatus[server])
                            .task {
                                if viewModel.serverStatus[server] == nil {
                                    await viewModel.pingServer(server)
                                }
                            }
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
        SettingsView(viewModel: SettingsViewModel.preview)
            .environmentObject(ServerService.preview)
    }
}
#endif
