//
//  SystemPingResponse.swift
//  GoPortApi
//
//  Created by Max Vissing on 14.01.22.
//

import Foundation

public typealias SystemPingResponse = [String: SystemPingResponseItem]

public struct SystemPingResponseSummary: Codable {
    public var goportVersion: String?
    public var contexts: SystemPingResponse
}

#if DEBUG
extension SystemPingResponseItem: FilePreviewableAsDict {
    public static var previewFilename: String { "SystemPingResponse" }
}

extension SystemPingResponseSummary: Previewable {
    public static var preview: SystemPingResponseSummary {
        return SystemPingResponseSummary(goportVersion: "v1", contexts: SystemPingResponse.preview)
    }
}
#endif
