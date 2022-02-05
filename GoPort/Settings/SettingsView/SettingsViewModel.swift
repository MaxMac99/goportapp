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
        var contextStatus: [GoPortContext:ConnectionStatus]
    }
    
    @Published private(set) var serverStatus = [Server:ServerStatus]()
    
    func pingServers() async {
        await withTaskGroup(of: Void.self) { group in
            for server in ServerService.shared.servers {
                group.addTask {
                    await self.pingServer(server)
                }
            }
            
            await group.waitForAll()
        }
    }
    
    func pingServer(_ server: Server) async {
        guard let index = ServerService.shared.servers.firstIndex(of: server) else { return }
        do {
            let response = try await ServerService.shared.servers[index].pingAll()
            serverStatus[server] = ServerStatus(status: .connected, contextStatus: Dictionary(uniqueKeysWithValues: response.contexts
                                                                                                .map({ key, value in
                return (context: key, connected: value.error == nil ? .connected : .disconnected)
            })
                                                                                                .sorted(by: {
                if $0.0.id == "default" {
                    return true
                }
                if $1.0.id == "default" {
                    return false
                }
                return $0.0.id < $1.0.id
            })))
        } catch {
            serverStatus[server] = ServerStatus(status: .disconnected, contextStatus: Dictionary(uniqueKeysWithValues: server.contexts
                                                                                                    .map({ key in
                return (context: key, connected: .disconnected)
            })
                                                                                                    .sorted(by: {
                if $0.0.id == "default" {
                    return true
                }
                if $1.0.id == "default" {
                    return false
                }
                return $0.0.id < $1.0.id
            })))
        }
    }
    
    func statusForServer(_ server: Server) -> ConnectionStatus {
        serverStatus[server]?.status ?? .connecting
    }
    
    func statusForContext(_ context: GoPortContext, in server: Server) -> ConnectionStatus {
        serverStatus[server]?.contextStatus[context] ?? .connecting
    }
}

#if DEBUG
extension SettingsViewModel {
    static let preview: SettingsViewModel = {
        let viewModel = SettingsViewModel()
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
            return (server, ServerStatus(status: status, contextStatus: server.contexts.enumerated().reduce(into: [GoPortContext:ConnectionStatus](), { partialResult, item in
                    let status2: ConnectionStatus
                    switch item.offset % 3 {
                    case 0:
                        status2 = .connected
                    case 1:
                        status2 = .connecting
                    default:
                        status2 = .disconnected
                    }
                    partialResult[item.element] = status2
                })))
            }))
        return viewModel
    }()
}
#endif
