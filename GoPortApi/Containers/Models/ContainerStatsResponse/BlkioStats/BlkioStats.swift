//
// BlkioStats.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation

public struct BlkioStats: Codable, Hashable {

    public var ioServiceBytesRecursive: [BlkioStatEntry]? = nil
    public var ioServicedRecursive: [BlkioStatEntry]? = nil
    public var ioQueuedRecursive: [BlkioStatEntry]? = nil
    public var ioServiceTimeRecursive: [BlkioStatEntry]? = nil
    public var ioWaitTimeRecursive: [BlkioStatEntry]? = nil
    public var ioMergedRecursive: [BlkioStatEntry]? = nil
    public var ioTimeRecursive: [BlkioStatEntry]? = nil
    public var sectorsRecursive: [BlkioStatEntry]? = nil

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case ioServiceBytesRecursive = "io_service_bytes_recursive"
        case ioServicedRecursive = "io_serviced_recursive"
        case ioQueuedRecursive = "io_queue_recursive"
        case ioServiceTimeRecursive = "io_service_time_recursive"
        case ioWaitTimeRecursive = "io_wait_time_recursive"
        case ioMergedRecursive = "io_merged_recursive"
        case ioTimeRecursive = "io_time_recursive"
        case sectorsRecursive = "sectors_recursive"
    }
}

