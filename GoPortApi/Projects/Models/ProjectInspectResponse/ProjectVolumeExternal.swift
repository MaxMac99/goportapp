import Foundation

public enum ProjectVolumeExternal: Codable {
    case bool(Bool)
    case projectStickyExternal(ProjectStickyExternal)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Bool.self) {
            self = .bool(x)
            return
        }
        if let x = try? container.decode(ProjectStickyExternal.self) {
            self = .projectStickyExternal(x)
            return
        }
        throw DecodingError.typeMismatch(ProjectVolumeExternal.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for ProjectVolumeExternal"))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .bool(let x):
            try container.encode(x)
        case .projectStickyExternal(let x):
            try container.encode(x)
        }
    }
}
