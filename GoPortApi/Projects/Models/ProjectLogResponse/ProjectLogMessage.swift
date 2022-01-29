//
// LogObjectLog.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation

public struct ProjectLogMessage: Codable, Hashable {

    public var service: String? = nil
    public var container: String? = nil
    public var message: String? = nil

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case service = "Service"
        case container = "Container"
        case message = "Message"
    }
}

