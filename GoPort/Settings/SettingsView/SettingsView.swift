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
    
    @State private var showAddServer = false
    
    var body: some View {
        NavigationView {
            List {
                if serverService.servers.isEmpty {
                    Button {
                         showAddServer = true
                    } label: {
                        Label("Add Server", systemImage: "plus.circle")
                    }
                }
                Section("Servers") {
                    ForEach(serverService.servers) { server in
                        ServerRowView(server: server, status: viewModel.serverStatus[server]?.status ?? .connecting, isSelected: serverService.selectedServer == server)
                            .task {
                                if viewModel.serverStatus[server] == nil {
                                    await viewModel.pingServer(server)
                                }
                            }
                        if let contexts = viewModel.serverStatus[serverService.servers.first!]?.contexts {
                            ForEach(contexts, id: \.context) { contextName, status in
                                ServerContextRowView(server: server, contextName: contextName, status: status)
                            }
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showAddServer = true
                    } label: {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            .navigationTitle("Settings")
        }
        .sheet(isPresented: $showAddServer) {
            AddServerView()
        }
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
