// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let projectDiscreteResourceSpec = try? newJSONDecoder().decode(ProjectDiscreteResourceSpec.self, from: jsonData)

import Foundation

// MARK: - ProjectDiscreteResourceSpec
public struct ProjectDiscreteResourceSpec: Codable {
    public var kind: String?
    public var value: Double?

    enum CodingKeys: String, CodingKey {
        case kind
        case value
    }

    public init(kind: String?, value: Double?) {
        self.kind = kind
        self.value = value
    }
}
