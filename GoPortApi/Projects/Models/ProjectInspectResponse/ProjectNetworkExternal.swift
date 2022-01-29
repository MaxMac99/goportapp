import Foundation

public enum ProjectNetworkExternal: Codable {
    case bool(Bool)
    case projectFluffyExternal(ProjectFluffyExternal)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Bool.self) {
            self = .bool(x)
            return
        }
        if let x = try? container.decode(ProjectFluffyExternal.self) {
            self = .projectFluffyExternal(x)
            return
        }
        throw DecodingError.typeMismatch(ProjectNetworkExternal.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for ProjectNetworkExternal"))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .bool(let x):
            try container.encode(x)
        case .projectFluffyExternal(let x):
            try container.encode(x)
        }
    }
}
