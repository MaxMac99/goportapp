// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let projectBlkioWeight = try? newJSONDecoder().decode(ProjectBlkioWeight.self, from: jsonData)

import Foundation

// MARK: - ProjectBlkioWeight
public struct ProjectBlkioWeight: Codable {
    public var path: String?
    public var weight: Int?

    enum CodingKeys: String, CodingKey {
        case path
        case weight
    }

    public init(path: String?, weight: Int?) {
        self.path = path
        self.weight = weight
    }
}
