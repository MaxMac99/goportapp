// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let projectReservations = try? newJSONDecoder().decode(ProjectReservations.self, from: jsonData)

import Foundation

// MARK: - ProjectReservations
public struct ProjectReservations: Codable {
    public var cpus: ProjectCPUPeriod?
    public var devices: [ProjectDevice]?
    public var genericResources: [ProjectGenericResource]?
    public var memory: String?

    enum CodingKeys: String, CodingKey {
        case cpus
        case devices
        case genericResources
        case memory
    }

    public init(cpus: ProjectCPUPeriod?, devices: [ProjectDevice]?, genericResources: [ProjectGenericResource]?, memory: String?) {
        self.cpus = cpus
        self.devices = devices
        self.genericResources = genericResources
        self.memory = memory
    }
}
