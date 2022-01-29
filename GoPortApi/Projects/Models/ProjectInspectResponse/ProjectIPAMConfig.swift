// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let projectIPAMConfig = try? newJSONDecoder().decode(ProjectIPAMConfig.self, from: jsonData)

import Foundation

// MARK: - ProjectIPAMConfig
public struct ProjectIPAMConfig: Codable {
    public var auxAddresses: [String: String]?
    public var gateway: String?
    public var ipRange: String?
    public var subnet: String?

    enum CodingKeys: String, CodingKey {
        case auxAddresses
        case gateway
        case ipRange
        case subnet
    }

    public init(auxAddresses: [String: String]?, gateway: String?, ipRange: String?, subnet: String?) {
        self.auxAddresses = auxAddresses
        self.gateway = gateway
        self.ipRange = ipRange
        self.subnet = subnet
    }
}
