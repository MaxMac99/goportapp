//
//  GoPortContext.swift
//  GoPortApi
//
//  Created by Max Vissing on 29.01.22.
//

import Foundation

public struct GoPortContext {
    public private(set) var name: String
    private var serverRef: Reference<Server>
    
    public var server: Server {
        serverRef.value
    }
    
    internal init(name: String, server: Server) {
        self.name = name
        self.serverRef = Reference(server)
    }
    
    internal var host: URL {
        server.host
    }
    internal var session: NetworkingSession {
        server.session
    }
}

extension GoPortContext: Equatable {
    public static func == (lhs: GoPortContext, rhs: GoPortContext) -> Bool {
        lhs.name == rhs.name && lhs.server.id == rhs.server.id
    }
}

extension GoPortContext: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}

extension GoPortContext: Identifiable {
    public var id: String { name }
}

extension Dictionary where Key == String {
    func dockerContext(_ name: String) throws -> Value {
        guard let result = self[name] else {
            throw ServerError.contextNotFound
        }
        return result
    }
}
