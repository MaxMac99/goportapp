// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let projectBuildClass = try? newJSONDecoder().decode(ProjectBuildClass.self, from: jsonData)

import Foundation

// MARK: - ProjectBuildClass
public struct ProjectBuildClass: Codable {
    public var args: ProjectListOrDict?
    public var cacheFrom: [String]?
    public var context: String?
    public var dockerfile: String?
    public var extraHosts: ProjectListOrDict?
    public var isolation: String?
    public var labels: ProjectListOrDict?
    public var network: String?
    public var shmSize: ProjectRate?
    public var target: String?

    enum CodingKeys: String, CodingKey {
        case args
        case cacheFrom
        case context
        case dockerfile
        case extraHosts
        case isolation
        case labels
        case network
        case shmSize
        case target
    }

    public init(args: ProjectListOrDict?, cacheFrom: [String]?, context: String?, dockerfile: String?, extraHosts: ProjectListOrDict?, isolation: String?, labels: ProjectListOrDict?, network: String?, shmSize: ProjectRate?, target: String?) {
        self.args = args
        self.cacheFrom = cacheFrom
        self.context = context
        self.dockerfile = dockerfile
        self.extraHosts = extraHosts
        self.isolation = isolation
        self.labels = labels
        self.network = network
        self.shmSize = shmSize
        self.target = target
    }
}
