// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let projectNetworkNetwork = try? newJSONDecoder().decode(ProjectNetworkNetwork.self, from: jsonData)

import Foundation

// MARK: - ProjectNetworkNetwork
public struct ProjectNetworkNetwork: Codable {
    public var attachable: Bool?
    public var driver: String?
    public var driverOpts: [String: JSONAny]?
    public var enableIpv6: Bool?
    public var external: ProjectNetworkExternal?
    public var networkInternal: Bool?
    public var ipam: ProjectIPAM?
    public var labels: ProjectListOrDict?
    public var name: String?

    enum CodingKeys: String, CodingKey {
        case attachable
        case driver
        case driverOpts
        case enableIpv6
        case external
        case networkInternal
        case ipam
        case labels
        case name
    }

    public init(attachable: Bool?, driver: String?, driverOpts: [String: JSONAny]?, enableIpv6: Bool?, external: ProjectNetworkExternal?, networkInternal: Bool?, ipam: ProjectIPAM?, labels: ProjectListOrDict?, name: String?) {
        self.attachable = attachable
        self.driver = driver
        self.driverOpts = driverOpts
        self.enableIpv6 = enableIpv6
        self.external = external
        self.networkInternal = networkInternal
        self.ipam = ipam
        self.labels = labels
        self.name = name
    }
}
