// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let projectFluffyExternal = try? newJSONDecoder().decode(ProjectFluffyExternal.self, from: jsonData)

import Foundation

// MARK: - ProjectFluffyExternal
public struct ProjectFluffyExternal: Codable {
    public var name: String?

    enum CodingKeys: String, CodingKey {
        case name
    }

    public init(name: String?) {
        self.name = name
    }
}
