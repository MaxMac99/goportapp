import Foundation

public enum ProjectConfigExternal: Codable {
    case bool(Bool)
    case projectPurpleExternal(ProjectPurpleExternal)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Bool.self) {
            self = .bool(x)
            return
        }
        if let x = try? container.decode(ProjectPurpleExternal.self) {
            self = .projectPurpleExternal(x)
            return
        }
        throw DecodingError.typeMismatch(ProjectConfigExternal.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for ProjectConfigExternal"))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .bool(let x):
            try container.encode(x)
        case .projectPurpleExternal(let x):
            try container.encode(x)
        }
    }
}
