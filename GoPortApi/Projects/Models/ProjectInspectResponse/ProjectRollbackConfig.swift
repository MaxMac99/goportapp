// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let projectRollbackConfig = try? newJSONDecoder().decode(ProjectRollbackConfig.self, from: jsonData)

import Foundation

// MARK: - ProjectRollbackConfig
public struct ProjectRollbackConfig: Codable {
    public var delay: String?
    public var failureAction: String?
    public var maxFailureRatio: Double?
    public var monitor: String?
    public var order: ProjectOrder?
    public var parallelism: Int?

    enum CodingKeys: String, CodingKey {
        case delay
        case failureAction
        case maxFailureRatio
        case monitor
        case order
        case parallelism
    }

    public init(delay: String?, failureAction: String?, maxFailureRatio: Double?, monitor: String?, order: ProjectOrder?, parallelism: Int?) {
        self.delay = delay
        self.failureAction = failureAction
        self.maxFailureRatio = maxFailureRatio
        self.monitor = monitor
        self.order = order
        self.parallelism = parallelism
    }
}
