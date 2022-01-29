// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let projectFluffyVolume = try? newJSONDecoder().decode(ProjectFluffyVolume.self, from: jsonData)

import Foundation

// MARK: - ProjectFluffyVolume
public struct ProjectFluffyVolume: Codable {
    public var nocopy: Bool?

    enum CodingKeys: String, CodingKey {
        case nocopy
    }

    public init(nocopy: Bool?) {
        self.nocopy = nocopy
    }
}
