//
//  ServerRowView.swift
//  GoPort
//
//  Created by Max Vissing on 25.12.21.
//

import SwiftUI
import GoPortApi

struct ServerRowView: View {
    var server: Server
    var status: ConnectionStatus
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(server.name)
                        .font(.headline)
                    Text(server.host.relativeString)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
                ConnectionStatusView(status: status)
            }
            .padding(.vertical, 5)
        }
    }
}

#if DEBUG
struct ServerRowView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                ServerRowView(server: Server.preview.first!, status: SettingsViewModel.preview.serverStatus[Server.preview.first!]!.status)
                ServerRowView(server: Server.preview[1], status: SettingsViewModel.preview.serverStatus[Server.preview[1]]!.status)
            }
        }
    }
}
#endif
