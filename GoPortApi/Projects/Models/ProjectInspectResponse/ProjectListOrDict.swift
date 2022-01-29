import Foundation

public enum ProjectListOrDict: Codable {
    case stringArray([String])
    case unionMap([String: ProjectListOrDictValue])

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode([String].self) {
            self = .stringArray(x)
            return
        }
        if let x = try? container.decode([String: ProjectListOrDictValue].self) {
            self = .unionMap(x)
            return
        }
        throw DecodingError.typeMismatch(ProjectListOrDict.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for ProjectListOrDict"))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .stringArray(let x):
            try container.encode(x)
        case .unionMap(let x):
            try container.encode(x)
        }
    }
}
