// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let projectPortClass = try? newJSONDecoder().decode(ProjectPortClass.self, from: jsonData)

import Foundation

// MARK: - ProjectPortClass
public struct ProjectPortClass: Codable {
    public var hostIP: String?
    public var mode: String?
    public var portProtocol: String?
    public var published: ProjectRate?
    public var target: Int?

    enum CodingKeys: String, CodingKey {
        case hostIP
        case mode
        case portProtocol
        case published
        case target
    }

    public init(hostIP: String?, mode: String?, portProtocol: String?, published: ProjectRate?, target: Int?) {
        self.hostIP = hostIP
        self.mode = mode
        self.portProtocol = portProtocol
        self.published = published
        self.target = target
    }
}
