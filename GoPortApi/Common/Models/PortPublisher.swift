//
// PortPublisher.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation

public struct PortPublisher: Codable, Hashable {

    public var URL: String? = nil
    public var targetPort: Int? = nil
    public var publishedPort: Int? = nil
    public var _protocol: String? = nil

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case URL
        case targetPort = "TargetPort"
        case publishedPort = "PublishedPort"
        case _protocol = "Protocol"
    }
}

