//
//  ServerService.swift
//  GoPort
//
//  Created by Max Vissing on 25.12.21.
//

import Foundation
import GoPortApi

class ServerService: ObservableObject {
    static let shared = ServerService()
    
    private init() {}
    
    enum SaveServerError: Error {
        case notCheckedURL
        case nameAlreadyExists
    }
    
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
        guard let goportVersion = response.goportVersion, GoPortAPI.supportedGoPortVersions.contains(goportVersion) else {
            throw ServerError.notSupported
        }
        
        let server = Server(name: name, host: host.appendingPathComponent(goportVersion))
        servers.append(server)
        if selectedServer == nil && !servers.isEmpty {
            selectedServer = servers.first
        }
    }
    
    func save(url: String, name: String) throws {
        guard !servers.contains(where: { $0.name == name }) else {
            throw SaveServerError.nameAlreadyExists
        }
        let server = Server(name: name, host: URL(string: url)!)
        servers.append(server)
        selectedServer = server
    }
    
    func select(_ server: Server) {
        guard servers.contains(server) else {
            return
        }
        selectedServer = server
    }
    
    func remove(_ server: Server) {
        guard let index = servers.firstIndex(of: server) else {
            return
        }
        servers.remove(at: index)
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
        let viewModel = ServerService()
        //viewModel.servers = Server.preview
        viewModel.selectedServer = viewModel.servers.first!
        return viewModel
    }()
}
#endif
