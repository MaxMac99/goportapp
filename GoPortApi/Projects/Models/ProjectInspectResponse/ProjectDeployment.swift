// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let projectDeployment = try? newJSONDecoder().decode(ProjectDeployment.self, from: jsonData)

import Foundation

// MARK: - ProjectDeployment
public struct ProjectDeployment: Codable {
    public var endpointMode: String?
    public var labels: ProjectListOrDict?
    public var mode: String?
    public var placement: ProjectPlacement?
    public var replicas: Int?
    public var resources: ProjectResources?
    public var restartPolicy: ProjectRestartPolicy?
    public var rollbackConfig: ProjectRollbackConfig?
    public var updateConfig: ProjectUpdateConfig?

    enum CodingKeys: String, CodingKey {
        case endpointMode
        case labels
        case mode
        case placement
        case replicas
        case resources
        case restartPolicy
        case rollbackConfig
        case updateConfig
    }

    public init(endpointMode: String?, labels: ProjectListOrDict?, mode: String?, placement: ProjectPlacement?, replicas: Int?, resources: ProjectResources?, restartPolicy: ProjectRestartPolicy?, rollbackConfig: ProjectRollbackConfig?, updateConfig: ProjectUpdateConfig?) {
        self.endpointMode = endpointMode
        self.labels = labels
        self.mode = mode
        self.placement = placement
        self.replicas = replicas
        self.resources = resources
        self.restartPolicy = restartPolicy
        self.rollbackConfig = rollbackConfig
        self.updateConfig = updateConfig
    }
}
