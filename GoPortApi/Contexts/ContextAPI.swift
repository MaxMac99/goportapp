//
//  ContextAPI.swift
//  GoPortApi
//
//  Created by Max Vissing on 28.12.21.
//

import Foundation

open class ContextAPI {
    
    /**
     Create a context
     - POST /contexts/create
     - parameter name: (path) Assign the specified name to the context. Must match &#x60;/?[a-zA-Z0-9][a-zA-Z0-9_.-]+&#x60;.
     - parameter body: (body) Context to create
     - returns: String
     */
    open class func contextCreate(host: URL, name: String, body: ContextConfig, session: NetworkingSession = NetworkingSession.shared) async throws {
        var localPath = "/contexts/{name}"
        localPath = localPath.replacingOccurrences(of: "{name}", with: APIHelper.mapToPathItem(name), options: .literal, range: nil)
        
        try await session.run(from: host, on: localPath, via: .POST, item: body)
    }
    
    /**
     Remove a context
     - DELETE /contexts/{name}
     - parameter name: (path) Name of the context
     - parameter force: (query) If the context is in use, force to remove it. (optional, default to false)
     
     */
    open class func contextDelete(host: URL, name: String, force: Bool = false, session: NetworkingSession = NetworkingSession.shared) async throws {
        var localPath = "/contexts/{name}"
        localPath = localPath.replacingOccurrences(of: "{name}", with: APIHelper.mapToPathItem(name), options: .literal, range: nil)
        let queryItems = APIHelper.mapValuesToQueryItems([
            "force": force,
        ])
        
        try await session.run(from: host, on: localPath, via: .DELETE, with: queryItems)
    }
    
    /**
     Inspect a context
     - GET /contexts/{name}/json
     - Return low-level information about a context.
     - parameter name: (path) Name of the context
     - returns: ContextInspectResponse
     */
    open class func contextInspect(host: URL, name: String, session: NetworkingSession = NetworkingSession.shared) async throws -> ContextInspectResponse {
        var localPath = "/contexts/{name}/json"
        localPath = localPath.replacingOccurrences(of: "{name}", with: APIHelper.mapToPathItem(name), options: .literal, range: nil)
        
        return try await session.load(from: host, on: localPath, via: .GET)
    }
    
    /**
     List contexts
     - GET /contexts/json
     - Returns a list of contexts. For details on the format, see the [inspect endpoint](#operation/ContextInspect).  Note that it uses a different, smaller representation of a context than inspecting a single context.
     - returns: [ContextSummary]
     */
    open class func contextList(host: URL, session: NetworkingSession = NetworkingSession.shared) async throws -> [ContextSummary] {
        let localPath = "/contexts/json"
        
        return try await session.load(from: host, on: localPath, via: .GET)
    }
    
    /**
     Update a context
     - POST /contexts/{name}/update
     - Change various configuration options of a context without having to recreate it.
     - parameter name: (path) Name of the context
     - parameter update: (body)
     
     */
    open class func contextUpdate(host: URL, name: String, update: ContextUpdateBody, session: NetworkingSession = NetworkingSession.shared) async throws {
        var localPath = "/contexts/{name}/update"
        localPath = localPath.replacingOccurrences(of: "{name}", with: APIHelper.mapToPathItem(name), options: .literal, range: nil)
        
        try await session.run(from: host, on: localPath, via: .POST, item: update)
    }
}
