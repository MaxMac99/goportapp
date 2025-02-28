//
// NetworkDisconnectConfig.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation

public struct NetworkDisconnectConfig: Codable, Hashable {

    /** The ID or name of the container to disconnect from the network.  */
    public var container: String? = nil
    /** Force the container to disconnect from the network.  */
    public var force: Bool? = nil

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case container = "Container"
        case force = "Force"
    }
}

