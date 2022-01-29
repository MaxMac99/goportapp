// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let projectCredentialSpec = try? newJSONDecoder().decode(ProjectCredentialSpec.self, from: jsonData)

import Foundation

// MARK: - ProjectCredentialSpec
public struct ProjectCredentialSpec: Codable {
    public var config: String?
    public var file: String?
    public var registry: String?

    enum CodingKeys: String, CodingKey {
        case config
        case file
        case registry
    }

    public init(config: String?, file: String?, registry: String?) {
        self.config = config
        self.file = file
        self.registry = registry
    }
}
