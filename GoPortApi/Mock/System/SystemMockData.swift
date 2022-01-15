//
//  SystemMockData.swift
//  GoPortApi
//
//  Created by Max Vissing on 14.01.22.
//

import Foundation

internal struct SystemMockData {
    internal static func mockDataForPath(components: [String], with encoder: JSONEncoder, method: HTTPMethod = .GET) throws -> Data? {
        switch (method, components.first) {
        case (.GET, "system"):
            return try encoder.encode(SystemDataUsageResponse.preview)
        case (.GET, "info"):
            return try encoder.encode(SystemInfoResponse.preview)
        case (.GET, "version"):
            return try encoder.encode(SystemVersionResponse.preview)
        case (.GET, "events"):
            return try encoder.encode(SystemEventsResponse.preview)
        case (.GET, "_ping"):
            return try encoder.encode(SystemPingResponse.preview)
        default:
            return nil
        }
    }
}

public extension SystemDataUsageResponse {
    static var previewFilename: String { "dataUsage" }
    static var preview: SystemDataUsageResponse {
        try! MockHelper.load(previewFilename)
    }
}

public extension SystemEventsResponse {
    static var previewFilename: String { "events" }
    static var preview: SystemEventsResponse {
        try! MockHelper.load(previewFilename)
    }
}

public extension SystemInfoResponse {
    static var previewFilename: String { "info" }
    static var preview: SystemInfoResponse {
        try! MockHelper.load(previewFilename)
    }
}

public extension SystemVersionResponse {
    static var previewFilename: String { "version" }
    static var preview: SystemVersionResponse {
        try! MockHelper.load(previewFilename)
    }
}

public extension SystemPingResponse {
    static var previewFilename: String { "ping" }
    static var preview: SystemPingResponse {
        try! MockHelper.load(previewFilename)
    }
}

public extension SystemPingHeader {
    static var previewFilename: String { "ping.header" }
    static var preview: SystemPingHeader {
        try! SystemPingHeader(MockHelper.loadHeaders(previewFilename))
    }
}

public extension SystemPingResponseSummary {
    static var preview: SystemPingResponseSummary {
        SystemPingResponseSummary(goportVersion: SystemPingHeader.preview.goportVersion, contexts: SystemPingResponse.preview)
    }
}
