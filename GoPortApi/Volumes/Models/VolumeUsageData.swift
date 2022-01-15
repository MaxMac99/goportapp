//
// VolumeUsageData.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation

/** Usage details about the volume. This information is used by the &#x60;GET /system/df&#x60; endpoint, and omitted in other endpoints.  */
public struct VolumeUsageData: Codable, Hashable {

    /** Amount of disk space used by the volume (in bytes). This information is only available for volumes created with the `\"local\"` volume driver. For volumes created with other volume drivers, this field is set to `-1` (\"not available\")  */
    public var size: Int64 = -1
    /** The number of containers referencing this volume. This field is set to `-1` if the reference-count is not available.  */
    public var refCount: Int64 = -1

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case size = "Size"
        case refCount = "RefCount"
    }
}

