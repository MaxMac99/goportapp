//
//  ServerContextRowView.swift
//  GoPort
//
//  Created by Max Vissing on 21.01.22.
//

import SwiftUI

struct ServerContextRowView: View {
    var server: Server
    var contextName: String
    var status: ConnectionStatus
    
    var body: some View {
        NavigationLink(destination: ContextDetailView(server: server, contextName: contextName)) {
            HStack {
                Text(contextName)
                Spacer()
                ConnectionStatusView(status: status)
            }
        }
        .padding(.leading, 16)
    }
}

struct ServerContextRowView_Previews: PreviewProvider {
    static var previews: some View {
        ServerContextRowView(server: Server.preview.first!, contextName: "default", status: .connected)
        ServerContextRowView(server: Server.preview[1], contextName: "default", status: .connecting)
        ServerContextRowView(server: Server.preview[2], contextName: "default", status: .disconnected)
    }
}
