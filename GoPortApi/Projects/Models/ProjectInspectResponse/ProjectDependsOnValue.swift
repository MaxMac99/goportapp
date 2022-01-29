// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let projectDependsOnValue = try? newJSONDecoder().decode(ProjectDependsOnValue.self, from: jsonData)

import Foundation

// MARK: - ProjectDependsOnValue
public struct ProjectDependsOnValue: Codable {
    public var condition: ProjectCondition

    enum CodingKeys: String, CodingKey {
        case condition
    }

    public init(condition: ProjectCondition) {
        self.condition = condition
    }
}
