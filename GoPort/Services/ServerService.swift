//
//  ServerService.swift
//  GoPort
//
//  Created by Max Vissing on 25.12.21.
//

import Foundation

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
    
    func validateServer(_ server: Server) throws {
        if servers.contains(where: {$0.name == server.name || $0.host == server.host}) {
            throw ServerError.alreadyExists
        }
    }
    
    func addServer(_ server: Server) throws {
        try validateServer(server)
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
