//
//  ServerService.swift
//  GoPort
//
//  Created by Max Vissing on 25.12.21.
//

import Foundation
import GoPortApi

class ServerService: ObservableObject {
    
    @Published fileprivate(set) var servers: [Server] = UserDefaults.standard.servers {
        didSet {
            UserDefaults.standard.servers = servers
        }
    }
    @Published var selectedServer: Server? = UserDefaults.standard.selectedServer {
        didSet {
            UserDefaults.standard.selectedServer = selectedServer
        }
    }
    
    func addServer(name: String, host: URL) async throws {
        if servers.contains(where: {$0.name == name || $0.host == host}) {
            throw ServerError.alreadyExists
        }
        
        let response = try await SystemAPI.systemPing(host: host)
        guard let goportVersion = response.goportVersion, GoPort.supportedGoPortVersions.contains(goportVersion) else {
            throw ServerError.notSupported
        }
        
        let server = Server(name: name, host: host.appendingPathComponent(goportVersion))
        servers.append(server)
        if selectedServer == nil && !servers.isEmpty {
            selectedServer = servers.first
        }
    }
    
    func removeServer(at offsets: IndexSet) {
        let serversToRemove = offsets.map { servers[$0].name }
        servers.remove(atOffsets: offsets)
        if serversToRemove.contains(where: {$0 == selectedServer?.name}) {
            selectedServer = servers.first
        }
    }
}

enum ServerError: Error {
    case alreadyExists
    case notSupported
}

fileprivate extension UserDefaults {
    @objc private var serversData: Data? {
        get {
            return data(forKey: "Servers")
        }
        set {
            set(newValue, forKey: "Servers")
        }
    }
    var servers: [Server] {
        get {
            return serversData.jsonDecoded([Server].self) ?? []
        }
        set {
            serversData = try? JSONEncoder().encode(newValue)
        }
    }
    
    @objc private var selectedServerData: Data? {
        get {
            return data(forKey: "SelectedServer")
        }
        set {
            set(newValue, forKey: "SelectedServer")
        }
    }
    var selectedServer: Server? {
        get {
            return selectedServerData.jsonDecoded(Server.self)
        }
        set {
            selectedServerData = try? JSONEncoder().encode(newValue)
        }
    }
}

#if DEBUG
extension ServerService {
    static var preview: ServerService {
        let viewModel = ServerService()
        viewModel.servers = Server.preview
        viewModel.selectedServer = viewModel.servers.first!
        return viewModel
    }
}
#endif
