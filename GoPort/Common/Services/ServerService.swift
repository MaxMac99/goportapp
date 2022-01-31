//
//  ServerService.swift
//  GoPort
//
//  Created by Max Vissing on 25.12.21.
//

import Foundation
import GoPortApi

@MainActor
class ServerService: ObservableObject {
    static let shared = ServerService()
    
    private init() {}
    
    fileprivate init(servers: [Server], selectedServer: Server?) {
        self.servers = servers
        self.selectedServer = selectedServer
    }
    
    enum SaveServerError: Error {
        case invalidURL
        case notCheckedURL
        case nameAlreadyExists
        case notSupported
    }
    
    @Published var servers: [Server] = UserDefaults.standard.servers {
        didSet {
            if let selectedServer = selectedServer {
                if servers.difference(from: oldValue).removals.map({ change -> Server? in
                    switch change {
                    case .remove(offset: _, element: let server, associatedWith: _):
                        return server
                    default:
                        break
                    }
                    return nil
                }).contains(selectedServer) {
                    self.selectedServer = nil
                }
            }
            UserDefaults.standard.servers = servers
        }
    }
    @Published var selectedServer: Server? = UserDefaults.standard.selectedServer {
        didSet {
            UserDefaults.standard.selectedServer = selectedServer
        }
    }
    
    func addServer(name: String, url: String) async throws {
        guard let host = URL(string: url) else {
            throw SaveServerError.notCheckedURL
        }
        guard !servers.contains(where: {$0.name == name || $0.host == host}) else {
            throw SaveServerError.nameAlreadyExists
        }
        
        var server = Server(name: name, host: host)
        let response = try await server.pingAll()
        guard let goportVersion = response.goportVersion, GoPortAPI.supportedGoPortVersions.contains(goportVersion) else {
            throw SaveServerError.notSupported
        }
        
        servers.append(server)
        if selectedServer == nil {
            selectedServer = servers.first
        }
    }
    
    func select(context: GoPortContext, on server: Server) {
        guard let index = servers.firstIndex(of: server) else { return }
        if selectedServer != server {
            selectedServer = server
        } else {
            servers[index].toggle(context: context)
        }
    }
    
    func remove(_ server: Server) {
        guard let index = servers.firstIndex(of: server) else {
            return
        }
        servers.remove(at: index)
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
    
    @objc private var selectedServerData: Data? {
        get {
            return data(forKey: "SelectedServer")
        }
        set {
            set(newValue, forKey: "SelectedServer")
        }
    }
}

extension UserDefaults {
    fileprivate(set) var servers: [Server] {
        get {
            return serversData.jsonDecoded([Server].self) ?? []
        }
        set {
            serversData = try? JSONEncoder().encode(newValue)
        }
    }
    fileprivate(set) var selectedServer: Server? {
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
    static let preview: ServerService = {
        ServerService(servers: Server.preview, selectedServer: Server.preview.first!)
    }()
}
#endif
