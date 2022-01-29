// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let projectInspectResponse = try? newJSONDecoder().decode(ProjectInspectResponse.self, from: jsonData)

import Foundation

/// The Compose file is a YAML file defining a multi-containers based application.
// MARK: - ProjectInspectResponse
public struct ProjectInspectResponse: Codable {
    public var configs: [String: ProjectConfigValue]?
    /// define the Compose project name, until user defines one explicitly.
    public var name: String?
    public var networks: [String: ProjectNetworkNetwork?]?
    public var secrets: [String: ProjectSecretValue]?
    public var services: [String: ProjectService]?
    /// declared for backward compatibility, ignored.
    public var version: String?
    public var volumes: [String: ProjectTentacledVolume?]?

    enum CodingKeys: String, CodingKey {
        case configs
        case name
        case networks
        case secrets
        case services
        case version
        case volumes
    }

    public init(configs: [String: ProjectConfigValue]?, name: String?, networks: [String: ProjectNetworkNetwork?]?, secrets: [String: ProjectSecretValue]?, services: [String: ProjectService]?, version: String?, volumes: [String: ProjectTentacledVolume?]?) {
        self.configs = configs
        self.name = name
        self.networks = networks
        self.secrets = secrets
        self.services = services
        self.version = version
        self.volumes = volumes
    }
}

#if DEBUG
extension ProjectInspectResponse: FilePreviewable {
    public static var previewFilename: String { "ProjectInspectResponse" }
}
#endif
