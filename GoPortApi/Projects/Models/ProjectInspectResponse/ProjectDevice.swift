// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let projectDevice = try? newJSONDecoder().decode(ProjectDevice.self, from: jsonData)

import Foundation

// MARK: - ProjectDevice
public struct ProjectDevice: Codable {
    public var capabilities: [String]?
    public var count: ProjectRate?
    public var deviceIDS: [String]?
    public var driver: String?
    public var options: ProjectListOrDict?

    enum CodingKeys: String, CodingKey {
        case capabilities
        case count
        case deviceIDS
        case driver
        case options
    }

    public init(capabilities: [String]?, count: ProjectRate?, deviceIDS: [String]?, driver: String?, options: ProjectListOrDict?) {
        self.capabilities = capabilities
        self.count = count
        self.deviceIDS = deviceIDS
        self.driver = driver
        self.options = options
    }
}
