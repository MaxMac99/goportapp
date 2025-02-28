//
// ContextInspectResponseStorage.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation

/** The path to the configuration of the context */
public struct ContextInspectResponseStorage: Codable, Hashable {

    /** The path to metadata files */
    public var metadataPath: String? = nil
    /** The path to TLS files */
    public var tLSPath: String? = nil

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case metadataPath = "MetadataPath"
        case tLSPath = "TLSPath"
    }
}

