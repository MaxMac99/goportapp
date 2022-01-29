import Foundation

public enum ProjectVolumeElement: Codable {
    case projectPurpleVolume(ProjectPurpleVolume)
    case string(String)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        if let x = try? container.decode(ProjectPurpleVolume.self) {
            self = .projectPurpleVolume(x)
            return
        }
        throw DecodingError.typeMismatch(ProjectVolumeElement.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for ProjectVolumeElement"))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .projectPurpleVolume(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}
