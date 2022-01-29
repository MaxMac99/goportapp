// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let projectLimits = try? newJSONDecoder().decode(ProjectLimits.self, from: jsonData)

import Foundation

// MARK: - ProjectLimits
public struct ProjectLimits: Codable {
    public var cpus: ProjectCPUPeriod?
    public var memory: String?
    public var pids: Int?

    enum CodingKeys: String, CodingKey {
        case cpus
        case memory
        case pids
    }

    public init(cpus: ProjectCPUPeriod?, memory: String?, pids: Int?) {
        self.cpus = cpus
        self.memory = memory
        self.pids = pids
    }
}
