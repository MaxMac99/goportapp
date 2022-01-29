import Foundation

public enum ProjectPortElement: Codable {
    case double(Double)
    case projectPortClass(ProjectPortClass)
    case string(String)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Double.self) {
            self = .double(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        if let x = try? container.decode(ProjectPortClass.self) {
            self = .projectPortClass(x)
            return
        }
        throw DecodingError.typeMismatch(ProjectPortElement.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for ProjectPortElement"))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .double(let x):
            try container.encode(x)
        case .projectPortClass(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}
