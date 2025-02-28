//
// VolumeAPI.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation

public struct VolumeAPI {
    
    internal enum VolumeAPIPath: APIPathProtocol {
        case volumeCreate
        case volumeDelete(name: String)
        case volumeInspect(name: String)
        case volumeList
        case volumePrune
        
        var path: String {
            switch self {
            case .volumeCreate: return "/volumes/create"
            case .volumeDelete(let name):
                var localPath = "/volumes/{name}"
                localPath = localPath.replacingOccurrences(of: "{name}", with: mapToPathItem(name), options: .literal, range: nil)
                return localPath
            case .volumeInspect(let name):
                var localPath = "/volumes/{name}"
                localPath = localPath.replacingOccurrences(of: "{name}", with: mapToPathItem(name), options: .literal, range: nil)
                return localPath
            case .volumeList: return "/volumes"
            case .volumePrune: return "/volumes/prune"
            }
        }
    }
    
    /**
     Create a volume
     - POST /volumes/create
     - parameter volumeConfig: (body)
     - parameter context: (query) The context to connect to. (optional)
     - returns: Volume
     */
    public static func volumeCreate(host: URL, volumeConfig: VolumeConfig, context: String? = nil, session: NetworkingSession = NetworkingSession.shared) async throws -> VolumeResponse {
        try await session.load(APIRequest(method: .POST, host: host, path: VolumeAPIPath.volumeCreate, query: [
            "context": context,
        ], body: volumeConfig))
    }
    
    /**
     Remove a volume
     - DELETE /volumes/{name}
     - Instruct the driver to remove the volume.
     - parameter name: (path) Volume name or ID
     - parameter context: (query) The context to connect to. (optional)
     - parameter force: (query) Force the removal of the volume (optional, default to false)
     
     */
    public static func volumeDelete(host: URL, name: String, context: String? = nil, force: Bool? = nil, session: NetworkingSession = NetworkingSession.shared) async throws {
        try await session.load(APIRequest(method: .DELETE, host: host, path: VolumeAPIPath.volumeDelete(name: name), query: [
            "context": context,
            "force": force,
        ]))
    }
    
    /**
     Inspect a volume
     - GET /volumes/{name}
     - parameter name: (path) Volume name or ID
     - parameter context: (query) The context to connect to. (optional)
     - returns: Volume
     */
    public static func volumeInspect(host: URL, name: String, context: String? = nil, session: NetworkingSession = NetworkingSession.shared) async throws -> VolumeResponse {
        try await session.load(APIRequest(method: .GET, host: host, path: VolumeAPIPath.volumeInspect(name: name), query: [
            "context": context,
        ]))
    }
    
    /**
     List volumes
     - GET /volumes
     - parameter context: (query) The contexts to connect to. (optional)
     - parameter filters: (query) JSON encoded value of the filters (a &#x60;map[string][]string&#x60;) to process on the volumes list. Available filters:  - &#x60;dangling&#x3D;&lt;boolean&gt;&#x60; When set to &#x60;true&#x60; (or &#x60;1&#x60;), returns all    volumes that are not in use by a container. When set to &#x60;false&#x60;    (or &#x60;0&#x60;), only volumes that are in use by one or more    containers are returned. - &#x60;driver&#x3D;&lt;volume-driver-name&gt;&#x60; Matches volumes based on their driver. - &#x60;label&#x3D;&lt;key&gt;&#x60; or &#x60;label&#x3D;&lt;key&gt;:&lt;value&gt;&#x60; Matches volumes based on    the presence of a &#x60;label&#x60; alone or a &#x60;label&#x60; and a value. - &#x60;name&#x3D;&lt;volume-name&gt;&#x60; Matches all or part of a volume name.  (optional)
     - returns: [String: VolumeListResponse]
     */
    public static func volumeList(host: URL, context: [String]? = nil, filters: String? = nil, session: NetworkingSession = NetworkingSession.shared) async throws -> VolumeListResponse {
        try await session.load(APIRequest(method: .GET, host: host, path: VolumeAPIPath.volumeList, query: [
            "context": context,
            "filters": filters,
        ]))
    }
    
    /**
     Delete unused volumes
     - POST /volumes/prune
     - parameter context: (query) The contexts to connect to. (optional)
     - parameter filters: (query) Filters to process on the prune list, encoded as JSON (a &#x60;map[string][]string&#x60;).  Available filters: - &#x60;label&#x60; (&#x60;label&#x3D;&lt;key&gt;&#x60;, &#x60;label&#x3D;&lt;key&gt;&#x3D;&lt;value&gt;&#x60;, &#x60;label!&#x3D;&lt;key&gt;&#x60;, or &#x60;label!&#x3D;&lt;key&gt;&#x3D;&lt;value&gt;&#x60;) Prune volumes with (or without, in case &#x60;label!&#x3D;...&#x60; is used) the specified labels.  (optional)
     - returns: VolumePruneResponse
     */
    public static func volumePrune(host: URL, context: [String]? = nil, filters: String? = nil, session: NetworkingSession = NetworkingSession.shared) async throws -> VolumePruneResponse {
        try await session.load(APIRequest(method: .POST, host: host, path: VolumeAPIPath.volumePrune, query: [
            "context": context,
            "filters": filters,
        ]))
    }
}
