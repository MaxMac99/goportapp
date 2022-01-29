// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let projectTmpfs = try? newJSONDecoder().decode(ProjectTmpfs.self, from: jsonData)

import Foundation

// MARK: - ProjectTmpfs
public struct ProjectTmpfs: Codable {
    public var size: ProjectSize?

    enum CodingKeys: String, CodingKey {
        case size
    }

    public init(size: ProjectSize?) {
        self.size = size
    }
}
