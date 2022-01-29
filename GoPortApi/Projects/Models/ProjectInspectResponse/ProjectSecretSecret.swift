// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let projectSecretSecret = try? newJSONDecoder().decode(ProjectSecretSecret.self, from: jsonData)

import Foundation

// MARK: - ProjectSecretSecret
public struct ProjectSecretSecret: Codable {
    public var gid: String?
    public var mode: Double?
    public var source: String?
    public var target: String?
    public var uid: String?

    enum CodingKeys: String, CodingKey {
        case gid
        case mode
        case source
        case target
        case uid
    }

    public init(gid: String?, mode: Double?, source: String?, target: String?, uid: String?) {
        self.gid = gid
        self.mode = mode
        self.source = source
        self.target = target
        self.uid = uid
    }
}
