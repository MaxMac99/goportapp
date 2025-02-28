//
// ContainersIdStatsNetworks.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation

public struct ContainersIdStatsNetworks: Codable, Hashable {

    public var rxBytes: Int? = nil
    public var rxPackets: Int? = nil
    public var rxErrors: Int? = nil
    public var rxDropped: Int? = nil
    public var txBytes: Int? = nil
    public var txPackets: Int? = nil
    public var txErrors: Int? = nil
    public var txDropped: Int? = nil
    public var endpointId: String? = nil
    public var instanceId: String? = nil

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case rxBytes = "rx_bytes"
        case rxPackets = "rx_packets"
        case rxErrors = "rx_errors"
        case rxDropped = "rx_dropped"
        case txBytes = "tx_bytes"
        case txPackets = "tx_packets"
        case txErrors = "tx_errors"
        case txDropped = "tx_dropped"
        case endpointId = "endpoint_id"
        case instanceId = "instance_id"
    }
}

