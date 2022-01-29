// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let projectSecretValue = try? newJSONDecoder().decode(ProjectSecretValue.self, from: jsonData)

import Foundation

// MARK: - ProjectSecretValue
public struct ProjectSecretValue: Codable {
    public var driver: String?
    public var driverOpts: [String: ProjectCPUPeriod]?
    public var external: ProjectSecretExternal?
    public var file: String?
    public var labels: ProjectListOrDict?
    public var name: String?
    public var templateDriver: String?

    enum CodingKeys: String, CodingKey {
        case driver
        case driverOpts
        case external
        case file
        case labels
        case name
        case templateDriver
    }

    public init(driver: String?, driverOpts: [String: ProjectCPUPeriod]?, external: ProjectSecretExternal?, file: String?, labels: ProjectListOrDict?, name: String?, templateDriver: String?) {
        self.driver = driver
        self.driverOpts = driverOpts
        self.external = external
        self.file = file
        self.labels = labels
        self.name = name
        self.templateDriver = templateDriver
    }
}
