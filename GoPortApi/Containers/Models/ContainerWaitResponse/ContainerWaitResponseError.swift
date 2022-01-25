//
// ContainerWaitResponseError.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation

/** container waiting error, if any */
public struct ContainerWaitResponseError: Codable, Hashable {

    /** Details of an error */
    public var message: String? = nil

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case message = "Message"
    }
}

