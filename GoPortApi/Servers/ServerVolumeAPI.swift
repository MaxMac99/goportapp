//
//  ServerVolumeAPI.swift
//  GoPortApi
//
//  Created by Max Vissing on 31.01.22.
//

import Foundation

extension Server {
    /**
     List volumes
     - GET /volumes
     - parameter filters: (query) JSON encoded value of the filters (a &#x60;map[string][]string&#x60;) to process on the volumes list. Available filters:  - &#x60;dangling&#x3D;&lt;boolean&gt;&#x60; When set to &#x60;true&#x60; (or &#x60;1&#x60;), returns all    volumes that are not in use by a container. When set to &#x60;false&#x60;    (or &#x60;0&#x60;), only volumes that are in use by one or more    containers are returned. - &#x60;driver&#x3D;&lt;volume-driver-name&gt;&#x60; Matches volumes based on their driver. - &#x60;label&#x3D;&lt;key&gt;&#x60; or &#x60;label&#x3D;&lt;key&gt;:&lt;value&gt;&#x60; Matches volumes based on    the presence of a &#x60;label&#x60; alone or a &#x60;label&#x60; and a value. - &#x60;name&#x3D;&lt;volume-name&gt;&#x60; Matches all or part of a volume name.  (optional)
     - returns: [String: VolumeListResponse]
     */
    public func volumes(filters: String? = nil) async throws -> [(context: GoPortContext, response: VolumeListResponseItem)] {
        try stringToDockerContext(try await VolumeAPI.volumeList(host: host, context: selectedContextsString, filters: filters, session: session))
    }
    
    /**
     Delete unused volumes
     - POST /volumes/prune
     - parameter filters: (query) Filters to process on the prune list, encoded as JSON (a &#x60;map[string][]string&#x60;).  Available filters: - &#x60;label&#x60; (&#x60;label&#x3D;&lt;key&gt;&#x60;, &#x60;label&#x3D;&lt;key&gt;&#x3D;&lt;value&gt;&#x60;, &#x60;label!&#x3D;&lt;key&gt;&#x60;, or &#x60;label!&#x3D;&lt;key&gt;&#x3D;&lt;value&gt;&#x60;) Prune volumes with (or without, in case &#x60;label!&#x3D;...&#x60; is used) the specified labels.  (optional)
     - returns: VolumePruneResponse
     */
    public func pruneVolumes(filters: String? = nil) async throws -> [(context: GoPortContext, response: VolumePruneResponseItem)] {
        try stringToDockerContext(try await VolumeAPI.volumePrune(host: host, context: selectedContextsString, filters: filters, session: session))
    }
}

extension GoPortContext {
    /**
     List volumes
     - GET /volumes
     - parameter filters: (query) JSON encoded value of the filters (a &#x60;map[string][]string&#x60;) to process on the volumes list. Available filters:  - &#x60;dangling&#x3D;&lt;boolean&gt;&#x60; When set to &#x60;true&#x60; (or &#x60;1&#x60;), returns all    volumes that are not in use by a container. When set to &#x60;false&#x60;    (or &#x60;0&#x60;), only volumes that are in use by one or more    containers are returned. - &#x60;driver&#x3D;&lt;volume-driver-name&gt;&#x60; Matches volumes based on their driver. - &#x60;label&#x3D;&lt;key&gt;&#x60; or &#x60;label&#x3D;&lt;key&gt;:&lt;value&gt;&#x60; Matches volumes based on    the presence of a &#x60;label&#x60; alone or a &#x60;label&#x60; and a value. - &#x60;name&#x3D;&lt;volume-name&gt;&#x60; Matches all or part of a volume name.  (optional)
     - returns: [String: VolumeListResponse]
     */
    public func volumes(filters: String? = nil) async throws -> VolumeListResponseItem {
        try await VolumeAPI.volumeList(host: host, context: [name], filters: filters, session: session).dockerContext(name)
    }
    
    /**
     Delete unused volumes
     - POST /volumes/prune
     - parameter filters: (query) Filters to process on the prune list, encoded as JSON (a &#x60;map[string][]string&#x60;).  Available filters: - &#x60;label&#x60; (&#x60;label&#x3D;&lt;key&gt;&#x60;, &#x60;label&#x3D;&lt;key&gt;&#x3D;&lt;value&gt;&#x60;, &#x60;label!&#x3D;&lt;key&gt;&#x60;, or &#x60;label!&#x3D;&lt;key&gt;&#x3D;&lt;value&gt;&#x60;) Prune volumes with (or without, in case &#x60;label!&#x3D;...&#x60; is used) the specified labels.  (optional)
     - returns: VolumePruneResponse
     */
    public func pruneVolumes(filters: String? = nil) async throws -> VolumePruneResponseItem {
        try await VolumeAPI.volumePrune(host: host, context: [name], filters: filters, session: session).dockerContext(name)
    }
    
    /**
     Create a volume
     - POST /volumes/create
     - parameter volumeConfig: (body)
     - parameter context: (query) The context to connect to. (optional)
     - returns: Volume
     */
    public func createVolume(volumeConfig: VolumeConfig) async throws -> VolumeResponse {
        try await VolumeAPI.volumeCreate(host: host, volumeConfig: volumeConfig, context: name, session: session)
    }
}

extension Volume {
    
    /**
     Remove a volume
     - DELETE /volumes/{name}
     - Instruct the driver to remove the volume.
     - parameter force: (query) Force the removal of the volume (optional, default to false)
     
     */
    public func delete(force: Bool? = nil) async throws {
        try await VolumeAPI.volumeDelete(host: context.host, name: id, context: context.name, force: force, session: context.session)
    }
    
    /**
     Inspect a volume
     - GET /volumes/{name}
     - returns: Volume
     */
    public func inspect() async throws -> VolumeResponse {
        try await VolumeAPI.volumeInspect(host: context.host, name: id, context: context.name, session: context.session)
    }
}
