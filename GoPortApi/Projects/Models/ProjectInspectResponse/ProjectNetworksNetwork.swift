// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let projectNetworksNetwork = try? newJSONDecoder().decode(ProjectNetworksNetwork.self, from: jsonData)

import Foundation

// MARK: - ProjectNetworksNetwork
public struct ProjectNetworksNetwork: Codable {
    public var aliases: [String]?
    public var ipv4Address: String?
    public var ipv6Address: String?
    public var linkLocalIPS: [String]?
    public var priority: Double?

    enum CodingKeys: String, CodingKey {
        case aliases
        case ipv4Address
        case ipv6Address
        case linkLocalIPS
        case priority
    }

    public init(aliases: [String]?, ipv4Address: String?, ipv6Address: String?, linkLocalIPS: [String]?, priority: Double?) {
        self.aliases = aliases
        self.ipv4Address = ipv4Address
        self.ipv6Address = ipv6Address
        self.linkLocalIPS = linkLocalIPS
        self.priority = priority
    }
}
