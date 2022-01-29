// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let projectTentacledExternal = try? newJSONDecoder().decode(ProjectTentacledExternal.self, from: jsonData)

import Foundation

// MARK: - ProjectTentacledExternal
public struct ProjectTentacledExternal: Codable {
    public var name: String?

    enum CodingKeys: String, CodingKey {
        case name
    }

    public init(name: String?) {
        self.name = name
    }
}
