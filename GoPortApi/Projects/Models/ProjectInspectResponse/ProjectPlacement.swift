// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let projectPlacement = try? newJSONDecoder().decode(ProjectPlacement.self, from: jsonData)

import Foundation

// MARK: - ProjectPlacement
public struct ProjectPlacement: Codable {
    public var constraints: [String]?
    public var maxReplicasPerNode: Int?
    public var preferences: [ProjectPreference]?

    enum CodingKeys: String, CodingKey {
        case constraints
        case maxReplicasPerNode
        case preferences
    }

    public init(constraints: [String]?, maxReplicasPerNode: Int?, preferences: [ProjectPreference]?) {
        self.constraints = constraints
        self.maxReplicasPerNode = maxReplicasPerNode
        self.preferences = preferences
    }
}
