// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let projectConfigValue = try? newJSONDecoder().decode(ProjectConfigValue.self, from: jsonData)

import Foundation

// MARK: - ProjectConfigValue
public struct ProjectConfigValue: Codable {
    public var external: ProjectConfigExternal?
    public var file: String?
    public var labels: ProjectListOrDict?
    public var name: String?
    public var templateDriver: String?

    enum CodingKeys: String, CodingKey {
        case external
        case file
        case labels
        case name
        case templateDriver
    }

    public init(external: ProjectConfigExternal?, file: String?, labels: ProjectListOrDict?, name: String?, templateDriver: String?) {
        self.external = external
        self.file = file
        self.labels = labels
        self.name = name
        self.templateDriver = templateDriver
    }
}
