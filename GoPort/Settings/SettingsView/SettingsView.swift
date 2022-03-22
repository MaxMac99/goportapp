//
//  SettingsView.swift
//  GoPort
//
//  Created by Max Vissing on 25.12.21.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var serverService: ServerService
    @StateObject var viewModel: SettingsViewModel
    
    @State private var showAddServer = false
    @Environment(\.editMode) var editMode
    
    init(viewModel: SettingsViewModel? = nil) {
        if let viewModel = viewModel {
            _viewModel = StateObject(wrappedValue: viewModel)
        } else {
            _viewModel = StateObject(wrappedValue: SettingsViewModel())
        }
    }
    
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
                        if let contexts = server.contexts, viewModel.statusForServer(server) != .disconnected {
                            ForEach(contexts) { context in
                                ServerContextRowView(context: context, status: viewModel.statusForContext(context, in: server), isSelected: Binding(get: {
                                    server == serverService.selectedServer && server.selectedContexts.contains(context)
                                }, set: { _ in
                                    serverService.select(context: context, on: server)
                                }))
                                    .deleteDisabled(true)
                                    .moveDisabled(contexts.count <= 1)
                            }
                            .onMove { indexSet, offset in
                                serverService.moveContext(on: server, fromOffset: indexSet, toOffset: offset)
                            }
                        }
                    }
                    .onDelete { indexSet in
                        serverService.servers.remove(atOffsets: indexSet)
                        if serverService.servers.isEmpty {
                            withAnimation {
                                editMode?.wrappedValue = .inactive
                            }
                        }
                    }
                }
            }
            .refreshable {
                await viewModel.pingServers()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showAddServer = true
                    } label: {
                        Label("Add Item", systemImage: "plus")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
            .navigationTitle("Settings")
        }
        .task {
            if viewModel.serverStatus.isEmpty {
                await viewModel.pingServers()
            }
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
