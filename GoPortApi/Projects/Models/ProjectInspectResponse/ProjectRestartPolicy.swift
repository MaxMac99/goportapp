// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let projectRestartPolicy = try? newJSONDecoder().decode(ProjectRestartPolicy.self, from: jsonData)

import Foundation

// MARK: - ProjectRestartPolicy
public struct ProjectRestartPolicy: Codable {
    public var condition: String?
    public var delay: String?
    public var maxAttempts: Int?
    public var window: String?

    enum CodingKeys: String, CodingKey {
        case condition
        case delay
        case maxAttempts
        case window
    }

    public init(condition: String?, delay: String?, maxAttempts: Int?, window: String?) {
        self.condition = condition
        self.delay = delay
        self.maxAttempts = maxAttempts
        self.window = window
    }
}
