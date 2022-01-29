// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let projectIPAM = try? newJSONDecoder().decode(ProjectIPAM.self, from: jsonData)

import Foundation

// MARK: - ProjectIPAM
public struct ProjectIPAM: Codable {
    public var config: [ProjectIPAMConfig]?
    public var driver: String?
    public var options: [String: String]?

    enum CodingKeys: String, CodingKey {
        case config
        case driver
        case options
    }

    public init(config: [ProjectIPAMConfig]?, driver: String?, options: [String: String]?) {
        self.config = config
        self.driver = driver
        self.options = options
    }
}
