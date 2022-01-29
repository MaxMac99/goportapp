// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let projectTentacledVolume = try? newJSONDecoder().decode(ProjectTentacledVolume.self, from: jsonData)

import Foundation

// MARK: - ProjectTentacledVolume
public struct ProjectTentacledVolume: Codable {
    public var driver: String?
    public var driverOpts: [String: ProjectCPUPeriod]?
    public var external: ProjectVolumeExternal?
    public var labels: ProjectListOrDict?
    public var name: String?

    enum CodingKeys: String, CodingKey {
        case driver
        case driverOpts
        case external
        case labels
        case name
    }

    public init(driver: String?, driverOpts: [String: ProjectCPUPeriod]?, external: ProjectVolumeExternal?, labels: ProjectListOrDict?, name: String?) {
        self.driver = driver
        self.driverOpts = driverOpts
        self.external = external
        self.labels = labels
        self.name = name
    }
}
