// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let projectStickyExternal = try? newJSONDecoder().decode(ProjectStickyExternal.self, from: jsonData)

import Foundation

// MARK: - ProjectStickyExternal
public struct ProjectStickyExternal: Codable {
    public var name: String?

    enum CodingKeys: String, CodingKey {
        case name
    }

    public init(name: String?) {
        self.name = name
    }
}
