import Foundation

public enum ProjectBuildUnion: Codable {
    case projectBuildClass(ProjectBuildClass)
    case string(String)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        if let x = try? container.decode(ProjectBuildClass.self) {
            self = .projectBuildClass(x)
            return
        }
        throw DecodingError.typeMismatch(ProjectBuildUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for ProjectBuildUnion"))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .projectBuildClass(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}
