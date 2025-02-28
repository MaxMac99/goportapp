//
// ImageResponse.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation

public struct ImageResponse: Codable, Hashable {

    public var id: String
    public var repoTags: [String]? = nil
    public var repoDigests: [String]? = nil
    public var parent: String
    public var comment: String
    public var created: Date
    public var container: String
    public var containerConfig: ContainerConfig? = nil
    public var dockerVersion: String
    public var author: String
    public var config: ContainerConfig? = nil
    public var architecture: String
    public var os: String
    public var osVersion: String? = nil
    public var size: Int64
    public var virtualSize: Int64
    public var graphDriver: GraphDriverData
    public var rootFS: ImageRootFS
    public var metadata: ImageMetadata? = nil

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case id = "Id"
        case repoTags = "RepoTags"
        case repoDigests = "RepoDigests"
        case parent = "Parent"
        case comment = "Comment"
        case created = "Created"
        case container = "Container"
        case containerConfig = "ContainerConfig"
        case dockerVersion = "DockerVersion"
        case author = "Author"
        case config = "Config"
        case architecture = "Architecture"
        case os = "Os"
        case osVersion = "OsVersion"
        case size = "Size"
        case virtualSize = "VirtualSize"
        case graphDriver = "GraphDriver"
        case rootFS = "RootFS"
        case metadata = "Metadata"
    }
}

#if DEBUG
extension ImageResponse: FilePreviewable {
    public static var previewFilename: String { "ImageResponse" }
}
#endif
