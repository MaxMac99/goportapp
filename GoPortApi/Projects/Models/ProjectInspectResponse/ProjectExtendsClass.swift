// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let projectExtendsClass = try? newJSONDecoder().decode(ProjectExtendsClass.self, from: jsonData)

import Foundation

// MARK: - ProjectExtendsClass
public struct ProjectExtendsClass: Codable {
    public var file: String?
    public var service: String

    enum CodingKeys: String, CodingKey {
        case file
        case service
    }

    public init(file: String?, service: String) {
        self.file = file
        self.service = service
    }
}
