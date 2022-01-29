import Foundation

public enum ProjectConfigUnion: Codable {
    case projectConfigConfig(ProjectConfigConfig)
    case string(String)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        if let x = try? container.decode(ProjectConfigConfig.self) {
            self = .projectConfigConfig(x)
            return
        }
        throw DecodingError.typeMismatch(ProjectConfigUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for ProjectConfigUnion"))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .projectConfigConfig(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}
