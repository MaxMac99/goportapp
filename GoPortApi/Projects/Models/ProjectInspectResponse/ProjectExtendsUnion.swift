import Foundation

public enum ProjectExtendsUnion: Codable {
    case projectExtendsClass(ProjectExtendsClass)
    case string(String)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        if let x = try? container.decode(ProjectExtendsClass.self) {
            self = .projectExtendsClass(x)
            return
        }
        throw DecodingError.typeMismatch(ProjectExtendsUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for ProjectExtendsUnion"))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .projectExtendsClass(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}
