// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let projectGenericResource = try? newJSONDecoder().decode(ProjectGenericResource.self, from: jsonData)

import Foundation

// MARK: - ProjectGenericResource
public struct ProjectGenericResource: Codable {
    public var discreteResourceSpec: ProjectDiscreteResourceSpec?

    enum CodingKeys: String, CodingKey {
        case discreteResourceSpec
    }

    public init(discreteResourceSpec: ProjectDiscreteResourceSpec?) {
        self.discreteResourceSpec = discreteResourceSpec
    }
}
