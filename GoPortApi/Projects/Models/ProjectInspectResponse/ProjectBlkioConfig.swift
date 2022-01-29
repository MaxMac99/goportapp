// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let projectBlkioConfig = try? newJSONDecoder().decode(ProjectBlkioConfig.self, from: jsonData)

import Foundation

// MARK: - ProjectBlkioConfig
public struct ProjectBlkioConfig: Codable {
    public var deviceReadBps: [ProjectBlkioLimit]?
    public var deviceReadIops: [ProjectBlkioLimit]?
    public var deviceWriteBps: [ProjectBlkioLimit]?
    public var deviceWriteIops: [ProjectBlkioLimit]?
    public var weight: Int?
    public var weightDevice: [ProjectBlkioWeight]?

    enum CodingKeys: String, CodingKey {
        case deviceReadBps
        case deviceReadIops
        case deviceWriteBps
        case deviceWriteIops
        case weight
        case weightDevice
    }

    public init(deviceReadBps: [ProjectBlkioLimit]?, deviceReadIops: [ProjectBlkioLimit]?, deviceWriteBps: [ProjectBlkioLimit]?, deviceWriteIops: [ProjectBlkioLimit]?, weight: Int?, weightDevice: [ProjectBlkioWeight]?) {
        self.deviceReadBps = deviceReadBps
        self.deviceReadIops = deviceReadIops
        self.deviceWriteBps = deviceWriteBps
        self.deviceWriteIops = deviceWriteIops
        self.weight = weight
        self.weightDevice = weightDevice
    }
}
