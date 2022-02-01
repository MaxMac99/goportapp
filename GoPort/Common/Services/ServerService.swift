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
        self.selectedServerRef = selectedServer?.name
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
                    self.selectedServerRef = servers.first?.name
                }
            }
            UserDefaults.standard.servers = servers
        }
    }
    var selectedServer: Server? {
        guard let ref = selectedServerRef else { return nil }
        return servers.first(where: { $0.name == ref })
    }
    private var selectedServerRef: String? = UserDefaults.standard.selectedServerRef {
        didSet {
            UserDefaults.standard.selectedServerRef = selectedServerRef
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
            selectedServerRef = servers.first?.name
        }
    }
    
    func select(context: GoPortContext, on server: Server) {
        guard let index = servers.firstIndex(of: server) else { return }
        if selectedServer != server {
            selectedServerRef = server.name
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
    
    func moveContext(on server: Server, fromOffset: IndexSet, toOffset: Int) {
        guard let index = servers.firstIndex(of: server) else {
            return
        }
        servers[index].moveContext(fromOffset: fromOffset, toOffset: toOffset)
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
    fileprivate var selectedServerRef: String? {
        get {
            return string(forKey: "SelectedServer")
        }
        set {
            set(newValue, forKey: "SelectedServer")
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
