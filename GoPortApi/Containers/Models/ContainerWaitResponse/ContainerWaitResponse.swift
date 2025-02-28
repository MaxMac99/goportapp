//
// ContainerWaitResponse.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation

/** OK response to ContainerWait operation */
public struct ContainerWaitResponse: Codable, Hashable {

    /** Exit code of the container */
    public var statusCode: Int64
    public var error: ContainerWaitResponseError? = nil

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case statusCode = "StatusCode"
        case error = "Error"
    }
}

#if DEBUG
extension ContainerWaitResponse: FilePreviewable {
    public static var previewFilename: String { "ContainerWaitResponse" }
}
#endif
