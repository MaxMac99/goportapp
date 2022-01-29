// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let projectPurpleVolume = try? newJSONDecoder().decode(ProjectPurpleVolume.self, from: jsonData)

import Foundation

// MARK: - ProjectPurpleVolume
public struct ProjectPurpleVolume: Codable {
    public var bind: ProjectBind?
    public var consistency: String?
    public var readOnly: Bool?
    public var source: String?
    public var target: String?
    public var tmpfs: ProjectTmpfs?
    public var type: String
    public var volume: ProjectFluffyVolume?

    enum CodingKeys: String, CodingKey {
        case bind
        case consistency
        case readOnly
        case source
        case target
        case tmpfs
        case type
        case volume
    }

    public init(bind: ProjectBind?, consistency: String?, readOnly: Bool?, source: String?, target: String?, tmpfs: ProjectTmpfs?, type: String, volume: ProjectFluffyVolume?) {
        self.bind = bind
        self.consistency = consistency
        self.readOnly = readOnly
        self.source = source
        self.target = target
        self.tmpfs = tmpfs
        self.type = type
        self.volume = volume
    }
}
