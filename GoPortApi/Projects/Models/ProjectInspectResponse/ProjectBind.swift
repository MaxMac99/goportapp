// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let projectBind = try? newJSONDecoder().decode(ProjectBind.self, from: jsonData)

import Foundation

// MARK: - ProjectBind
public struct ProjectBind: Codable {
    public var createHostPath: Bool?
    public var propagation: String?
    public var selinux: ProjectSelinux?

    enum CodingKeys: String, CodingKey {
        case createHostPath
        case propagation
        case selinux
    }

    public init(createHostPath: Bool?, propagation: String?, selinux: ProjectSelinux?) {
        self.createHostPath = createHostPath
        self.propagation = propagation
        self.selinux = selinux
    }
}
