//
// EndpointSettings.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation

/** Configuration for a network endpoint. */
public struct EndpointSettings: Codable, Hashable {

    public var iPAMConfig: EndpointIPAMConfig? = nil
    public var links: [String]? = nil
    public var aliases: [String]? = nil
    /** Unique ID of the network.  */
    public var networkID: String? = nil
    /** Unique ID for the service endpoint in a Sandbox.  */
    public var endpointID: String? = nil
    /** Gateway address for this network.  */
    public var gateway: String? = nil
    /** IPv4 address.  */
    public var iPAddress: String? = nil
    /** Mask length of the IPv4 address.  */
    public var iPPrefixLen: Int? = nil
    /** IPv6 gateway address.  */
    public var iPv6Gateway: String? = nil
    /** Global IPv6 address.  */
    public var globalIPv6Address: String? = nil
    /** Mask length of the global IPv6 address.  */
    public var globalIPv6PrefixLen: Int? = nil
    /** MAC address for the endpoint on this network.  */
    public var macAddress: String? = nil
    /** DriverOpts is a mapping of driver options and values. These options are passed directly to the driver and are driver specific.  */
    public var driverOpts: [String: String]? = nil

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case iPAMConfig = "IPAMConfig"
        case links = "Links"
        case aliases = "Aliases"
        case networkID = "NetworkID"
        case endpointID = "EndpointID"
        case gateway = "Gateway"
        case iPAddress = "IPAddress"
        case iPPrefixLen = "IPPrefixLen"
        case iPv6Gateway = "IPv6Gateway"
        case globalIPv6Address = "GlobalIPv6Address"
        case globalIPv6PrefixLen = "GlobalIPv6PrefixLen"
        case macAddress = "MacAddress"
        case driverOpts = "DriverOpts"
    }
}

