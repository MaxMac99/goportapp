//
//  ServerNetworkAPI.swift
//  GoPortApi
//
//  Created by Max Vissing on 31.01.22.
//

import Foundation

extension Server {
    
    /**
     List networks
     - GET /networks
     - Returns a list of networks. For details on the format, see the [network inspect endpoint](#operation/NetworkInspect).  Note that it uses a different, smaller representation of a network than inspecting a single network. For example, the list of containers attached to the network is not propagated in API versions 1.28 and up.
     - parameter context: (query) The contexts to connect to. (optional)
     - parameter filters: (query) JSON encoded value of the filters (a &#x60;map[string][]string&#x60;) to process on the networks list.  Available filters:  - &#x60;dangling&#x3D;&lt;boolean&gt;&#x60; When set to &#x60;true&#x60; (or &#x60;1&#x60;), returns all    networks that are not in use by a container. When set to &#x60;false&#x60;    (or &#x60;0&#x60;), only networks that are in use by one or more    containers are returned. - &#x60;driver&#x3D;&lt;driver-name&gt;&#x60; Matches a network&#39;s driver. - &#x60;id&#x3D;&lt;network-id&gt;&#x60; Matches all or part of a network ID. - &#x60;label&#x3D;&lt;key&gt;&#x60; or &#x60;label&#x3D;&lt;key&gt;&#x3D;&lt;value&gt;&#x60; of a network label. - &#x60;name&#x3D;&lt;network-name&gt;&#x60; Matches all or part of a network name. - &#x60;scope&#x3D;[\&quot;swarm\&quot;|\&quot;global\&quot;|\&quot;local\&quot;]&#x60; Filters networks by scope (&#x60;swarm&#x60;, &#x60;global&#x60;, or &#x60;local&#x60;). - &#x60;type&#x3D;[\&quot;custom\&quot;|\&quot;builtin\&quot;]&#x60; Filters networks by type. The &#x60;custom&#x60; keyword returns all user-defined networks.  (optional)
     - returns: [String: [Network]]
     */
    public func networks(filters: String? = nil) async throws -> [(context: GoPortContext, response: [NetworkResponse])] {
        try stringToDockerContext(try await NetworkAPI.networkList(host: host, context: selectedContextsString, filters: filters, session: session))
    }
    
    /**
     Delete unused networks
     - POST /networks/prune
     - parameter context: (query) The contexts to connect to. (optional)
     - parameter filters: (query) Filters to process on the prune list, encoded as JSON (a &#x60;map[string][]string&#x60;).  Available filters: - &#x60;until&#x3D;&lt;timestamp&gt;&#x60; Prune networks created before this timestamp. The &#x60;&lt;timestamp&gt;&#x60; can be Unix timestamps, date formatted timestamps, or Go duration strings (e.g. &#x60;10m&#x60;, &#x60;1h30m&#x60;) computed relative to the daemon machine’s time. - &#x60;label&#x60; (&#x60;label&#x3D;&lt;key&gt;&#x60;, &#x60;label&#x3D;&lt;key&gt;&#x3D;&lt;value&gt;&#x60;, &#x60;label!&#x3D;&lt;key&gt;&#x60;, or &#x60;label!&#x3D;&lt;key&gt;&#x3D;&lt;value&gt;&#x60;) Prune networks with (or without, in case &#x60;label!&#x3D;...&#x60; is used) the specified labels.  (optional)
     - returns: NetworkPruneResponse
     */
    public func pruneNetworks(filters: String? = nil) async throws -> [(context: GoPortContext, response: NetworkPruneResponseItem)] {
        try stringToDockerContext(try await NetworkAPI.networkPrune(host: host, context: selectedContextsString, filters: filters, session: session))
    }
}

extension GoPortContext {
    
    /**
     List networks
     - GET /networks
     - Returns a list of networks. For details on the format, see the [network inspect endpoint](#operation/NetworkInspect).  Note that it uses a different, smaller representation of a network than inspecting a single network. For example, the list of containers attached to the network is not propagated in API versions 1.28 and up.
     - parameter context: (query) The contexts to connect to. (optional)
     - parameter filters: (query) JSON encoded value of the filters (a &#x60;map[string][]string&#x60;) to process on the networks list.  Available filters:  - &#x60;dangling&#x3D;&lt;boolean&gt;&#x60; When set to &#x60;true&#x60; (or &#x60;1&#x60;), returns all    networks that are not in use by a container. When set to &#x60;false&#x60;    (or &#x60;0&#x60;), only networks that are in use by one or more    containers are returned. - &#x60;driver&#x3D;&lt;driver-name&gt;&#x60; Matches a network&#39;s driver. - &#x60;id&#x3D;&lt;network-id&gt;&#x60; Matches all or part of a network ID. - &#x60;label&#x3D;&lt;key&gt;&#x60; or &#x60;label&#x3D;&lt;key&gt;&#x3D;&lt;value&gt;&#x60; of a network label. - &#x60;name&#x3D;&lt;network-name&gt;&#x60; Matches all or part of a network name. - &#x60;scope&#x3D;[\&quot;swarm\&quot;|\&quot;global\&quot;|\&quot;local\&quot;]&#x60; Filters networks by scope (&#x60;swarm&#x60;, &#x60;global&#x60;, or &#x60;local&#x60;). - &#x60;type&#x3D;[\&quot;custom\&quot;|\&quot;builtin\&quot;]&#x60; Filters networks by type. The &#x60;custom&#x60; keyword returns all user-defined networks.  (optional)
     - returns: [String: [Network]]
     */
    public func networks(filters: String? = nil) async throws -> [NetworkResponse] {
        try await NetworkAPI.networkList(host: host, context: [name], filters: filters, session: session).dockerContext(name)
    }
    
    /**
     Delete unused networks
     - POST /networks/prune
     - parameter context: (query) The contexts to connect to. (optional)
     - parameter filters: (query) Filters to process on the prune list, encoded as JSON (a &#x60;map[string][]string&#x60;).  Available filters: - &#x60;until&#x3D;&lt;timestamp&gt;&#x60; Prune networks created before this timestamp. The &#x60;&lt;timestamp&gt;&#x60; can be Unix timestamps, date formatted timestamps, or Go duration strings (e.g. &#x60;10m&#x60;, &#x60;1h30m&#x60;) computed relative to the daemon machine’s time. - &#x60;label&#x60; (&#x60;label&#x3D;&lt;key&gt;&#x60;, &#x60;label&#x3D;&lt;key&gt;&#x3D;&lt;value&gt;&#x60;, &#x60;label!&#x3D;&lt;key&gt;&#x60;, or &#x60;label!&#x3D;&lt;key&gt;&#x3D;&lt;value&gt;&#x60;) Prune networks with (or without, in case &#x60;label!&#x3D;...&#x60; is used) the specified labels.  (optional)
     - returns: NetworkPruneResponse
     */
    public func pruneNetworks(filters: String? = nil) async throws -> NetworkPruneResponseItem {
        try await NetworkAPI.networkPrune(host: host, context: [name], filters: filters, session: session).dockerContext(name)
    }
    
    /**
     Create a network
     - POST /networks/create
     - parameter networkConfig: (body)
     - parameter context: (query) The context to connect to. (optional)
     - returns: NetworkCreateResponse
     */
    public func createNetwork(networkConfig: NetworkConfig) async throws -> NetworkCreateResponse {
        try await NetworkAPI.networkCreate(host: host, networkConfig: networkConfig, context: name, session: session)
    }
}

extension Network {
    /**
     Connect a container to a network
     - POST /networks/{id}/connect
     - parameter container: (body)
     
     */
    public func connect(container: NetworkContainerConnectConfig) async throws {
        try await NetworkAPI.networkConnect(host: context.host, id: id, container: container, context: context.name, session: context.session)
    }
    
    /**
     Remove a network
     - DELETE /networks/{id}
     
     */
    public func delete() async throws {
        try await NetworkAPI.networkDelete(host: context.host, id: id, context: context.name, session: context.session)
    }
    
    /**
     Disconnect a container from a network
     - POST /networks/{id}/disconnect
     - parameter id: (path) Network ID or name
     - parameter container: (body)
     - parameter context: (query) The context to connect to. (optional)
     
     */
    public func disconnect(container: NetworkDisconnectConfig) async throws {
        try await NetworkAPI.networkDisconnect(host: context.host, id: id, container: container, context: context.name, session: context.session)
    }
    
    /**
     Inspect a network
     - GET /networks/{id}
     - parameter verbose: (query) Detailed inspect output for troubleshooting (optional, default to false)
     - parameter scope: (query) Filter the network by scope (swarm, global, or local) (optional)
     - returns: Network
     */
    public func inspect(verbose: Bool = false, scope: String? = nil) async throws -> NetworkResponse {
        try await NetworkAPI.networkInspect(host: context.host, id: id, context: context.name, verbose: verbose, scope: scope, session: context.session)
    }
}
