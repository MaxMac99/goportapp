// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let projectPreference = try? newJSONDecoder().decode(ProjectPreference.self, from: jsonData)

import Foundation

// MARK: - ProjectPreference
public struct ProjectPreference: Codable {
    public var spread: String?

    enum CodingKeys: String, CodingKey {
        case spread
    }

    public init(spread: String?) {
        self.spread = spread
    }
}
