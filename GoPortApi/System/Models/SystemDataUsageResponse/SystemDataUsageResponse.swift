//
// SystemDataUsageResponse.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation

public typealias SystemDataUsageResponse = [String:SystemDataUsageResponseItem]

public struct SystemDataUsageResponseItem: Codable, Hashable {

    public var layersSize: Int64? = nil
    public var images: [ImageSummary]? = nil
    public var containers: [ContainerSummary]? = nil
    public var volumes: [Volume]? = nil
    public var buildCache: [BuildCache]? = nil

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case layersSize = "LayersSize"
        case images = "Images"
        case containers = "Containers"
        case volumes = "Volumes"
        case buildCache = "BuildCache"
    }
}

#if DEBUG
extension SystemDataUsageResponseItem: FilePreviewableAsDict {
    public static var previewFilename: String { "dataUsage" }
}
#endif
