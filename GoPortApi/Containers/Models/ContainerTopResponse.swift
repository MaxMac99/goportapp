//
// ContainerTopResponse.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation

/** OK response to ContainerTop operation */
public struct ContainerTopResponse: Codable, Hashable {

    /** The ps column titles */
    public var titles: [String]? = nil
    /** Each process running in the container, where each is process is an array of values corresponding to the titles.  */
    public var processes: [[String]]? = nil

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case titles = "Titles"
        case processes = "Processes"
    }
}

#if DEBUG
extension ContainerTopResponse: FilePreviewable {
    public static var previewFilename: String { "ContainerTopResponse" }
}
#endif
