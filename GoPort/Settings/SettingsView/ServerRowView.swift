//
//  ServerRowView.swift
//  GoPort
//
//  Created by Max Vissing on 25.12.21.
//

import SwiftUI

struct ServerRowView: View {
    var server: Server
    var status: SettingsViewModel.ServerStatus?
    var isSelected: Bool = false
    
    @State private var mainSelected = false
    @State private var contextSelected = [String:Bool]()
    
    var body: some View {
        VStack(spacing: 8) {
            NavigationLink(destination: ContextDetailView(viewModel: ContextDetailViewModel(server: server)), isActive: $mainSelected) {
                HStack(spacing: 4) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(server.name)
                            .font(.headline)
                        Text(server.host.relativeString)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    if isSelected {
                        Image(systemName: "checkmark")
                            .foregroundColor(Color.accentColor)
                    }
                    ConnectionStatusView(status: status?.status)
                }
                .padding(.vertical, 5)
                .onTapGesture {
                    mainSelected = true
                }
            }
            if let status = status {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Contexts")
                        .font(.subheadline)
                    ForEach(status.contexts, id: \.context) { context, connectionStatus in
                        NavigationLink(destination: ContextDetailView(viewModel: ContextDetailViewModel(server: server, contextName: context)), isActive: Binding(get: {
                            contextSelected[context] ?? false
                        }, set: { value in
                            contextSelected[context] = value
                        })) {
                            HStack {
                                Text(context)
                                Spacer()
                                ConnectionStatusView(status: connectionStatus)
                            }
                        }
                        .padding(.vertical, 6)
                        .padding(.horizontal, 8)
                        .overlay {
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.gray, lineWidth: 0.5)
                        }
                        .onTapGesture {
                            contextSelected[context] = true
                        }
                    }
                }
            }
        }
    }
}

#if DEBUG
struct ServerRowView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                ServerRowView(server: Server.preview.first!, status: SettingsViewModel.preview.serverStatus[Server.preview.first!]!)
                ServerRowView(server: Server.preview[1], status: SettingsViewModel.preview.serverStatus[Server.preview[1]]!,  isSelected: true)
                ServerRowView(server: Server.preview[2], status: SettingsViewModel.preview.serverStatus[Server.preview[2]]!,  isSelected: true)
            }
        }
    }
}
#endif
