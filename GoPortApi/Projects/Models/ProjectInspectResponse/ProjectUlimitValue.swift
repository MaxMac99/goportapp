import Foundation

public enum ProjectUlimitValue: Codable {
    case integer(Int)
    case projectUlimitClass(ProjectUlimitClass)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(ProjectUlimitClass.self) {
            self = .projectUlimitClass(x)
            return
        }
        throw DecodingError.typeMismatch(ProjectUlimitValue.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for ProjectUlimitValue"))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .projectUlimitClass(let x):
            try container.encode(x)
        }
    }
}
