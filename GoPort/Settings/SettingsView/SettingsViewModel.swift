//
//  SettingsViewModel.swift
//  GoPort
//
//  Created by Max Vissing on 14.01.22.
//

import Foundation
import GoPortApi

@MainActor
class SettingsViewModel: ObservableObject {
    
    struct ServerStatus {
        var status: ConnectionStatus
        var contexts: [(context: String, status: ConnectionStatus)]
    }
    
    @Published private(set) var serverStatus = [Server:ServerStatus]()
    
    private let session: NetworkingSession
    
    init(session: NetworkingSession = NetworkingSession.shared) {
        self.session = session
    }
    
    func pingServer(_ server: Server) async {
        do {
            let response = try await SystemAPI.systemPing(host: server.host, context: ["all"], session: session)
            serverStatus[server] = ServerStatus(status: .connected, contexts: response.contexts
                .map({ key, value in
                    return (context: key, connected: value.error == nil ? .connected : .disconnected)
                })
                .sorted(by: { $0.context > $1.context}))
        } catch {
            serverStatus[server] = nil
        }
    }
}

#if DEBUG
extension SettingsViewModel {
    static let preview: SettingsViewModel = {
        let viewModel = SettingsViewModel(session: NetworkingSession.preview)
        viewModel.serverStatus = Dictionary(uniqueKeysWithValues: Server.preview.enumerated()
            .map({ index, server in
                let status: ConnectionStatus
                switch index % 3 {
                case 0:
                    status = .connected
                case 1:
                    status = .connecting
                default:
                    status = .disconnected
                }
                return (server, ServerStatus(status: status, contexts: [
                    ("default", .connected),
                    ("remote", .disconnected)
                ]))
            }))
        return viewModel
    }()
}
#endif
