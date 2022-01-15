//
//  SystemAPI.swift
//  GoPortApi
//
//  Created by Max Vissing on 30.12.21.
//

import Foundation

open class SystemAPI {
    
    /**
     Get data usage information
     - GET /system/df
     - parameter context: (query) The contexts to connect to. (optional)
     - returns: SystemDataUsageResponse
     */
    open class func systemDataUsage(host: URL, context: [String]? = nil, session: NetworkingSession = NetworkingSession.shared) async throws -> SystemDataUsageResponse {
        let localPath = "/system/df"
        let queryItems = APIHelper.mapValuesToQueryItems([
            "context": context,
        ])
        
        return try await session.load(from: host, on: localPath, via: .GET, with: queryItems)
    }
    
    /**
     Monitor events
     - GET /events
     - Stream real-time events from the server.  Various objects within Docker report events when something happens to them.  Containers report these events: `attach`, `commit`, `copy`, `create`, `destroy`,  `detach`, `die`, `exec_create`, `exec_detach`, `exec_start`, `exec_die`, `export`,  `health_status`, `kill`, `oom`, `pause`, `rename`, `resize`, `restart`, `start`,  `stop`, `top`, `unpause`, `update`, and `prune`  Images report these events: `delete`, `import`, `load`, `pull`, `push`, `save`, `tag`, `untag`, and `prune`  Volumes report these events: `create`, `mount`, `unmount`, `destroy`, and `prune`  Networks report these events: `create`, `connect`, `disconnect`, `destroy`, `update`, `remove`, and `prune`  The Docker daemon reports these events: `reload`  Services report these events: `create`, `update`, and `remove`  Nodes report these events: `create`, `update`, and `remove`  Secrets report these events: `create`, `update`, and `remove`  Configs report these events: `create`, `update`, and `remove`  The Builder reports `prune` events
     - parameter context: (query) The contexts to connect to. (optional)
     - parameter since: (query) Show events created since this timestamp then stream new events. (optional)
     - parameter until: (query) Show events created until this timestamp then stop streaming. (optional)
     - parameter filters: (query) A JSON encoded value of filters (a &#x60;map[string][]string&#x60;) to process on the event list. Available filters:  - &#x60;config&#x3D;&lt;string&gt;&#x60; config name or ID - &#x60;container&#x3D;&lt;string&gt;&#x60; container name or ID - &#x60;daemon&#x3D;&lt;string&gt;&#x60; daemon name or ID - &#x60;event&#x3D;&lt;string&gt;&#x60; event type - &#x60;image&#x3D;&lt;string&gt;&#x60; image name or ID - &#x60;label&#x3D;&lt;string&gt;&#x60; image or container label - &#x60;network&#x3D;&lt;string&gt;&#x60; network name or ID - &#x60;node&#x3D;&lt;string&gt;&#x60; node ID - &#x60;plugin&#x60;&#x3D;&lt;string&gt; plugin name or ID - &#x60;scope&#x60;&#x3D;&lt;string&gt; local or swarm - &#x60;secret&#x3D;&lt;string&gt;&#x60; secret name or ID - &#x60;service&#x3D;&lt;string&gt;&#x60; service name or ID - &#x60;type&#x3D;&lt;string&gt;&#x60; object to filter by, one of &#x60;container&#x60;, &#x60;image&#x60;, &#x60;volume&#x60;, &#x60;network&#x60;, &#x60;daemon&#x60;, &#x60;plugin&#x60;, &#x60;node&#x60;, &#x60;service&#x60;, &#x60;secret&#x60; or &#x60;config&#x60; - &#x60;volume&#x3D;&lt;string&gt;&#x60; volume name  (optional)
     - returns: SystemEventsResponse
     */
    open class func systemEvents(host: URL, context: [String]? = nil, since: String? = nil, until: String? = nil, filters: String? = nil, session: NetworkingSession = NetworkingSession.shared) async throws -> AsyncThrowingMapSequence<AsyncThrowingStream<Data, Error>, SystemEventsResponse> {
        let localPath = "/events"
        let queryItems = APIHelper.mapValuesToQueryItems([
            "context": context,
            
            "since": since,
            
            "until": until,
            
            "filters": filters,
        ])
        
        return try await session.stream(from: host, on: localPath, via: .GET, hasJSONResponse: true,  with: queryItems)
    }
    
    /**
     Get system information
     - GET /info
     - parameter context: (query) The contexts to connect to. (optional)
     - returns: SystemInfoResponse
     */
    open class func systemInfo(host: URL, context: [String]? = nil, session: NetworkingSession = NetworkingSession.shared) async throws -> SystemInfoResponse {
        let localPath = "/info"
        let queryItems = APIHelper.mapValuesToQueryItems([
            "context": context,
        ])
        
        return try await session.load(from: host, on: localPath, via: .GET, with: queryItems)
    }
    
    /**
     Ping
     - GET /_ping
     - This is a dummy endpoint you can use to test if the server is accessible.
     - responseHeaders: [Docker-Experimental(Bool), Cache-Control(String), Pragma(String), API-Version(String), Builder-Version(String)]
     - parameter context: (query) The context to connect to. (optional)
     - returns: String
     */
    open class func systemPing(host: URL, context: [String]? = nil, session: NetworkingSession = NetworkingSession.shared) async throws -> SystemPingResponseSummary {
        let localPath = "/_ping"
        let queryItems = APIHelper.mapValuesToQueryItems([
            "context": context,
        ])
        
        let (contexts, response): (SystemPingResponse, HTTPURLResponse) = try await session.load(from: host, on: localPath, via: .GET, with: queryItems)
        let goportVersion = response.allHeaderFields["Goport-Version"] as? String
        return SystemPingResponseSummary(goportVersion: goportVersion, contexts: contexts)
    }
    
    /**
     Ping
     - HEAD /_ping
     - This is a dummy endpoint you can use to test if the server is accessible.
     - responseHeaders: [Docker-Experimental(Bool), Cache-Control(String), Pragma(String), API-Version(String), Builder-Version(String)]
     - parameter context: (query) The context to connect to. (optional)
     - returns: String
     */
    open class func systemPingHead(host: URL, context: String? = nil, session: NetworkingSession = NetworkingSession.shared) async throws -> SystemPingHeader {
        let localPath = "/_ping"
        let queryItems = APIHelper.mapValuesToQueryItems([
            "context": context,
        ])
        
        let response: HTTPURLResponse = try await session.load(from: host, on: localPath, via: .HEAD, with: queryItems)
        return try SystemPingHeader(response.allHeaderFields)
    }
    
    /**
     Get version
     - GET /version
     - Returns the version of Docker that is running and various information about the system that Docker is running on.
     - parameter context: (query) The context to connect to. (optional)
     - returns: SystemVersionResponse
     */
    open class func systemVersion(host: URL, context: String? = nil, session: NetworkingSession = NetworkingSession.shared) async throws -> SystemVersionResponse {
        let localPath = "/version"
        let queryItems = APIHelper.mapValuesToQueryItems([
            "context": context,
        ])
        
        return try await session.load(from: host, on: localPath, via: .GET, with: queryItems)
    }
}

