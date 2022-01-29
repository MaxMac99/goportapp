// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let projectPurpleExternal = try? newJSONDecoder().decode(ProjectPurpleExternal.self, from: jsonData)

import Foundation

// MARK: - ProjectPurpleExternal
public struct ProjectPurpleExternal: Codable {
    public var name: String?

    enum CodingKeys: String, CodingKey {
        case name
    }

    public init(name: String?) {
        self.name = name
    }
}
