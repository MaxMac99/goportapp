import Foundation

public enum ProjectSecretExternal: Codable {
    case bool(Bool)
    case projectTentacledExternal(ProjectTentacledExternal)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Bool.self) {
            self = .bool(x)
            return
        }
        if let x = try? container.decode(ProjectTentacledExternal.self) {
            self = .projectTentacledExternal(x)
            return
        }
        throw DecodingError.typeMismatch(ProjectSecretExternal.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for ProjectSecretExternal"))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .bool(let x):
            try container.encode(x)
        case .projectTentacledExternal(let x):
            try container.encode(x)
        }
    }
}
