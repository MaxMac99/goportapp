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
                Section("Servers") {
                    if serverService.servers.isEmpty {
                        Button {
                            showAddServer = true
                        } label: {
                            Label("Add Server", systemImage: "plus.circle")
                        }
                    }
                    ForEach(serverService.servers) { server in
                        ServerRowView(server: server, status: viewModel.statusForServer(server))
                            .task {
                                await viewModel.pingServer(server)
                            }
                        if let contexts = server.contexts, viewModel.statusForServer(server) != .disconnected {
                            ForEach(contexts.sorted(by: {
                                if $0.name == "default" {
                                    return true
                                }
                                if $1.name == "default" {
                                    return false
                                }
                                return $0.name < $1.name
                            })) { context in
                                ServerContextRowView(context: context, status: viewModel.statusForContext(context, in: server), isSelected: Binding(get: {
                                    server == serverService.selectedServer && server.selectedContexts.contains(context)
                                }, set: { _ in
                                    serverService.select(context: context, on: server)
                                }))
                                    .deleteDisabled(true)
                            }
                        }
                    }
                    .onDelete { indexSet in
                        serverService.servers.remove(atOffsets: indexSet)
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
