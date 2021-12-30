//
//  ServerDetailView.swift
//  GoPort
//
//  Created by Max Vissing on 29.12.21.
//

import SwiftUI
import GoPortApi

struct ServerDetailView: View {
    var server: Server
    @StateObject var contextService = ContextService()
    
    var body: some View {
        List {
            Section {
                HStack {
                    Text("Host: ")
                        .font(.headline)
                    Text(server.host.absoluteString)
                }
            }
            Section("Contexts") {
                ForEach(contextService.contexts) { context in
                    VStack(alignment: .leading) {
                        Text(context.name)
                            .font(.headline)
                        if let docker = context.docker {
                            Text(docker)
                        }
                    }
                    .padding(.vertical, 5)
                }
            }
        }
        .navigationTitle(server.name)
        .task {
            do {
                try await contextService.load(from: server.host)
            } catch {
                print("Error loading: \(error.localizedDescription)")
            }
        }
    }
}

struct ServerDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ServerDetailView(server: Server.preview.first!, contextService: ContextService.preview)
        }
    }
}
