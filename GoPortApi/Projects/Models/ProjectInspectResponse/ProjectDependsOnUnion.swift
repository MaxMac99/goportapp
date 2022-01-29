import Foundation

public enum ProjectDependsOnUnion: Codable {
    case projectDependsOnValueMap([String: ProjectDependsOnValue])
    case stringArray([String])

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode([String].self) {
            self = .stringArray(x)
            return
        }
        if let x = try? container.decode([String: ProjectDependsOnValue].self) {
            self = .projectDependsOnValueMap(x)
            return
        }
        throw DecodingError.typeMismatch(ProjectDependsOnUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for ProjectDependsOnUnion"))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .projectDependsOnValueMap(let x):
            try container.encode(x)
        case .stringArray(let x):
            try container.encode(x)
        }
    }
}
