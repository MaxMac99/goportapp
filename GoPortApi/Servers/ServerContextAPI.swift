//
//  ServerContextAPI.swift
//  GoPortApi
//
//  Created by Max Vissing on 30.01.22.
//

import Foundation

extension Server {
    
    /**
     List contexts
     - GET /contexts/json
     - Returns a list of contexts. For details on the format, see the [inspect endpoint](#operation/ContextInspect).  Note that it uses a different, smaller representation of a context than inspecting a single context.
     - returns: [ContextSummary]
     */
    public mutating func contexts() async throws -> [ContextSummary] {
        let response = try await ContextAPI.contextList(host: host, session: session)
        updateContexts(response.map({ $0.id }))
        return response
    }
    
    /**
     Create a context
     - POST /contexts/{name}
     - parameter name: (path) Assign the specified name to the context. Must match &#x60;/?[a-zA-Z0-9][a-zA-Z0-9_.-]+&#x60;.
     - parameter body: (body) Context to create
     - returns: String
     */
    public func createContext(name: String, body: ContextConfig) async throws -> GoPortContext {
        GoPortContext(name: try await ContextAPI.contextCreate(host: host, name: name, body: body, session: session), server: self)
    }
}

extension GoPortContext {
    
    /**
     Remove a context
     - DELETE /contexts/{name}
     - parameter force: (query) If the context is in use, force to remove it. (optional, default to false)
     
     */
    public func remove(force: Bool? = nil) async throws {
        try await ContextAPI.contextDelete(host: host, name: name, force: force, session: session)
    }
    
    /**
     Inspect a context
     - GET /contexts/{name}/json
     - Return low-level information about a context.
     - returns: ContextInspectResponse
     */
    public func inspect() async throws -> ContextInspectResponse {
        try await ContextAPI.contextInspect(host: host, name: name, session: session)
    }
    
    /**
     Update a context
     - POST /contexts/{name}/update
     - Change various configuration options of a context without having to recreate it.
     - parameter update: (body)
     
     */
    public func update(update: ContextUpdateBody) async throws {
        try await ContextAPI.contextUpdate(host: host, name: name, update: update, session: session)
    }
}
