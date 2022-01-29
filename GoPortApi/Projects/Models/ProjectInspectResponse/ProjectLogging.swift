// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let projectLogging = try? newJSONDecoder().decode(ProjectLogging.self, from: jsonData)

import Foundation

// MARK: - ProjectLogging
public struct ProjectLogging: Codable {
    public var driver: String?
    public var options: [String: JSONAny]?

    enum CodingKeys: String, CodingKey {
        case driver
        case options
    }

    public init(driver: String?, options: [String: JSONAny]?) {
        self.driver = driver
        self.options = options
    }
}
