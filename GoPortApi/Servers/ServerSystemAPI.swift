//
//  ServerSystemAPI.swift
//  GoPortApi
//
//  Created by Max Vissing on 29.01.22.
//

import Foundation

public struct ServerPingResponse {
    public var goportVersion: String?
    public var contexts: [GoPortContext:SystemPingResponseItem]
}

extension Server {
    
    /**
     Get data usage information
     - GET /system/df
     - returns: [GoPortContext: SystemDataUsageResponseItem]
     */
    public func dataUsage() async throws -> [GoPortContext:SystemDataUsageResponseItem] {
        try stringToDockerContext(try await SystemAPI.systemDataUsage(host: host, context: selectedContextsString, session: session))
    }
    
    /**
     Monitor events
     - GET /events
     - Stream real-time events from the server.  Various objects within Docker report events when something happens to them.  Containers report these events: `attach`, `commit`, `copy`, `create`, `destroy`,  `detach`, `die`, `exec_create`, `exec_detach`, `exec_start`, `exec_die`, `export`,  `health_status`, `kill`, `oom`, `pause`, `rename`, `resize`, `restart`, `start`,  `stop`, `top`, `unpause`, `update`, and `prune`  Images report these events: `delete`, `import`, `load`, `pull`, `push`, `save`, `tag`, `untag`, and `prune`  Volumes report these events: `create`, `mount`, `unmount`, `destroy`, and `prune`  Networks report these events: `create`, `connect`, `disconnect`, `destroy`, `update`, `remove`, and `prune`  The Docker daemon reports these events: `reload`  Services report these events: `create`, `update`, and `remove`  Nodes report these events: `create`, `update`, and `remove`  Secrets report these events: `create`, `update`, and `remove`  Configs report these events: `create`, `update`, and `remove`  The Builder reports `prune` events
     - parameter since: (query) Show events created since this timestamp then stream new events. (optional)
     - parameter until: (query) Show events created until this timestamp then stop streaming. (optional)
     - parameter filters: (query) A JSON encoded value of filters (a &#x60;map[string][]string&#x60;) to process on the event list. Available filters:  - &#x60;config&#x3D;&lt;string&gt;&#x60; config name or ID - &#x60;container&#x3D;&lt;string&gt;&#x60; container name or ID - &#x60;daemon&#x3D;&lt;string&gt;&#x60; daemon name or ID - &#x60;event&#x3D;&lt;string&gt;&#x60; event type - &#x60;image&#x3D;&lt;string&gt;&#x60; image name or ID - &#x60;label&#x3D;&lt;string&gt;&#x60; image or container label - &#x60;network&#x3D;&lt;string&gt;&#x60; network name or ID - &#x60;node&#x3D;&lt;string&gt;&#x60; node ID - &#x60;plugin&#x60;&#x3D;&lt;string&gt; plugin name or ID - &#x60;scope&#x60;&#x3D;&lt;string&gt; local or swarm - &#x60;secret&#x3D;&lt;string&gt;&#x60; secret name or ID - &#x60;service&#x3D;&lt;string&gt;&#x60; service name or ID - &#x60;type&#x3D;&lt;string&gt;&#x60; object to filter by, one of &#x60;container&#x60;, &#x60;image&#x60;, &#x60;volume&#x60;, &#x60;network&#x60;, &#x60;daemon&#x60;, &#x60;plugin&#x60;, &#x60;node&#x60;, &#x60;service&#x60;, &#x60;secret&#x60; or &#x60;config&#x60; - &#x60;volume&#x3D;&lt;string&gt;&#x60; volume name  (optional)
     - returns: SystemEventsResponse
     */
    public func events(since: String? = nil, until: String? = nil, filters: String? = nil) async throws -> some AsyncSequence {
        try await SystemAPI.systemEvents(host: host, context: selectedContextsString, since: since, until: until, filters: filters, session: session).stream.map { events in
            try stringToDockerContext(events)
        }
    }
    
    /**
     Get system information
     - GET /info
     - returns: [GoPortContext: SystemInfoResponse]
     */
    public func info() async throws -> [GoPortContext:SystemInfoResponseItem] {
        try stringToDockerContext(try await SystemAPI.systemInfo(host: host, context: selectedContextsString, session: session))
    }
    
    /**
     Ping
     - GET /_ping
     - This is a dummy endpoint you can use to test if the server is accessible.
     - returns: SystemPingResponseSummary
     */
    @discardableResult
    public func ping() async throws -> ServerPingResponse {
        let response = try await SystemAPI.systemPing(host: host, context: selectedContextsString, session: session)
        return ServerPingResponse(goportVersion: response.goportVersion, contexts: try stringToDockerContext(response.contexts))
    }
    
    /**
     Ping
     - GET /_ping
     - This is a dummy endpoint you can use to test if the server is accessible.
     - returns: SystemPingResponseSummary
     */
    @discardableResult
    public mutating func pingAll() async throws -> ServerPingResponse {
        let response = try await SystemAPI.systemPing(host: host, context: ["all"], session: session)
        updateContexts(Array(response.contexts.keys))
        return ServerPingResponse(goportVersion: response.goportVersion, contexts: try stringToDockerContext(response.contexts))
    }
}

extension GoPortContext {
    
    /**
     Get data usage information
     - GET /system/df
     - returns: SystemDataUsageResponseItem
     */
    public func dataUsage() async throws -> SystemDataUsageResponseItem {
        try await SystemAPI.systemDataUsage(host: host, context: [name], session: session).dockerContext(name)
    }
    
    /**
     Monitor events
     - GET /events
     - Stream real-time events from the server.  Various objects within Docker report events when something happens to them.  Containers report these events: `attach`, `commit`, `copy`, `create`, `destroy`,  `detach`, `die`, `exec_create`, `exec_detach`, `exec_start`, `exec_die`, `export`,  `health_status`, `kill`, `oom`, `pause`, `rename`, `resize`, `restart`, `start`,  `stop`, `top`, `unpause`, `update`, and `prune`  Images report these events: `delete`, `import`, `load`, `pull`, `push`, `save`, `tag`, `untag`, and `prune`  Volumes report these events: `create`, `mount`, `unmount`, `destroy`, and `prune`  Networks report these events: `create`, `connect`, `disconnect`, `destroy`, `update`, `remove`, and `prune`  The Docker daemon reports these events: `reload`  Services report these events: `create`, `update`, and `remove`  Nodes report these events: `create`, `update`, and `remove`  Secrets report these events: `create`, `update`, and `remove`  Configs report these events: `create`, `update`, and `remove`  The Builder reports `prune` events
     - parameter since: (query) Show events created since this timestamp then stream new events. (optional)
     - parameter until: (query) Show events created until this timestamp then stop streaming. (optional)
     - parameter filters: (query) A JSON encoded value of filters (a &#x60;map[string][]string&#x60;) to process on the event list. Available filters:  - &#x60;config&#x3D;&lt;string&gt;&#x60; config name or ID - &#x60;container&#x3D;&lt;string&gt;&#x60; container name or ID - &#x60;daemon&#x3D;&lt;string&gt;&#x60; daemon name or ID - &#x60;event&#x3D;&lt;string&gt;&#x60; event type - &#x60;image&#x3D;&lt;string&gt;&#x60; image name or ID - &#x60;label&#x3D;&lt;string&gt;&#x60; image or container label - &#x60;network&#x3D;&lt;string&gt;&#x60; network name or ID - &#x60;node&#x3D;&lt;string&gt;&#x60; node ID - &#x60;plugin&#x60;&#x3D;&lt;string&gt; plugin name or ID - &#x60;scope&#x60;&#x3D;&lt;string&gt; local or swarm - &#x60;secret&#x3D;&lt;string&gt;&#x60; secret name or ID - &#x60;service&#x3D;&lt;string&gt;&#x60; service name or ID - &#x60;type&#x3D;&lt;string&gt;&#x60; object to filter by, one of &#x60;container&#x60;, &#x60;image&#x60;, &#x60;volume&#x60;, &#x60;network&#x60;, &#x60;daemon&#x60;, &#x60;plugin&#x60;, &#x60;node&#x60;, &#x60;service&#x60;, &#x60;secret&#x60; or &#x60;config&#x60; - &#x60;volume&#x3D;&lt;string&gt;&#x60; volume name  (optional)
     - returns: SystemEventsResponse
     */
    public func events(since: String? = nil, until: String? = nil, filters: String? = nil) async throws -> some AsyncSequence {
        try await SystemAPI.systemEvents(host: host, context: [name], since: since, until: until, filters: filters, session: session).stream.map { value -> SystemEventsResponseItem in
            try value.dockerContext(name)
        }
    }
    
    /**
     Get system information
     - GET /info
     - parameter context: (query) The contexts to connect to. (optional)
     - returns: SystemInfoResponse
     */
    public func info() async throws -> SystemInfoResponseItem {
        try await SystemAPI.systemInfo(host: host, context: [name], session: session).dockerContext(name)
    }
    
    
    
    /**
     Ping
     - GET /_ping
     - This is a dummy endpoint you can use to test if the server is accessible.
     - responseHeaders: [Docker-Experimental(Bool), Cache-Control(String), Pragma(String), API-Version(String), Builder-Version(String)]
     - returns: String
     */
    public func ping() async throws -> (goportVersion: String?, ping: SystemPingResponseItem) {
        let response = try await SystemAPI.systemPing(host: host, context: [name], session: session)
        return (goportVersion: response.goportVersion, ping: try response.contexts.dockerContext(name))
    }
    
    /**
     Ping
     - HEAD /_ping
     - This is a dummy endpoint you can use to test if the server is accessible.
     - responseHeaders: [Docker-Experimental(Bool), Cache-Control(String), Pragma(String), API-Version(String), Builder-Version(String)]
     - returns: String
     */
    public func pingHead() async throws -> SystemPingHeader {
        try await SystemAPI.systemPingHead(host: host, context: name, session: session)
    }
    
    /**
     Get version
     - GET /version
     - Returns the version of Docker that is running and various information about the system that Docker is running on.
     - returns: SystemVersionResponse
     */
    public func version() async throws -> SystemVersionResponse {
        try await SystemAPI.systemVersion(host: host, context: name, session: session)
    }
}
