// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let projectUlimitClass = try? newJSONDecoder().decode(ProjectUlimitClass.self, from: jsonData)

import Foundation

// MARK: - ProjectUlimitClass
public struct ProjectUlimitClass: Codable {
    public var hard: Int
    public var soft: Int

    enum CodingKeys: String, CodingKey {
        case hard
        case soft
    }

    public init(hard: Int, soft: Int) {
        self.hard = hard
        self.soft = soft
    }
}
