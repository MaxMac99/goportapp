//
//  ProjectListResponse.swift
//  GoPortApi
//
//  Created by Max Vissing on 05.02.22.
//

import Foundation

public struct ProjectListResponse: Codable {
    public var stored: [ProjectSummary]?
    public var remote: [String: [ProjectSummary]]
    
    public enum CodingKeys: String, CodingKey, CaseIterable {
        case stored = "Stored"
        case remote = "Remote"
    }
}

#if DEBUG
extension ProjectListResponse: FilePreviewable {
    public static var previewFilename: String { "ProjectListResponse" }
}
#endif
