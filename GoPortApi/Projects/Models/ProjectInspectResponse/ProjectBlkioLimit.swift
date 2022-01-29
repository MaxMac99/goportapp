// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let projectBlkioLimit = try? newJSONDecoder().decode(ProjectBlkioLimit.self, from: jsonData)

import Foundation

// MARK: - ProjectBlkioLimit
public struct ProjectBlkioLimit: Codable {
    public var path: String?
    public var rate: ProjectRate?

    enum CodingKeys: String, CodingKey {
        case path
        case rate
    }

    public init(path: String?, rate: ProjectRate?) {
        self.path = path
        self.rate = rate
    }
}
