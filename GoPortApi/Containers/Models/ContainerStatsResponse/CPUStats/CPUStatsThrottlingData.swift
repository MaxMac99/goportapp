//
// CPUStatsThrottlingData.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation

public struct CPUStatsThrottlingData: Codable, Hashable {

    public var periods: Int? = nil
    public var throttledPeriod: Int? = nil
    public var throttledtime: Int? = nil

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case periods = "periods"
        case throttledPeriod = "throttled_periods"
        case throttledtime = "throttled_time"
    }
}

