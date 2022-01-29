import Foundation

public enum ProjectSecretElement: Codable {
    case projectSecretSecret(ProjectSecretSecret)
    case string(String)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        if let x = try? container.decode(ProjectSecretSecret.self) {
            self = .projectSecretSecret(x)
            return
        }
        throw DecodingError.typeMismatch(ProjectSecretElement.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for ProjectSecretElement"))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .projectSecretSecret(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}
