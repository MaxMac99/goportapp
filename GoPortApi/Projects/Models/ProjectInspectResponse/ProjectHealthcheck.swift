// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let projectHealthcheck = try? newJSONDecoder().decode(ProjectHealthcheck.self, from: jsonData)

import Foundation

// MARK: - ProjectHealthcheck
public struct ProjectHealthcheck: Codable {
    public var disable: Bool?
    public var interval: String?
    public var retries: Double?
    public var startPeriod: String?
    public var test: ProjectStringOrList?
    public var timeout: String?

    enum CodingKeys: String, CodingKey {
        case disable
        case interval
        case retries
        case startPeriod
        case test
        case timeout
    }

    public init(disable: Bool?, interval: String?, retries: Double?, startPeriod: String?, test: ProjectStringOrList?, timeout: String?) {
        self.disable = disable
        self.interval = interval
        self.retries = retries
        self.startPeriod = startPeriod
        self.test = test
        self.timeout = timeout
    }
}
