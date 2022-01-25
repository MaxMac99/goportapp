//
//  ProgressResponse.swift
//  GoPortApi
//
//  Created by Max Vissing on 23.01.22.
//

import Foundation

public struct ProgressResponse: Codable, Hashable {
    
    public var id: String? = nil
    public var status: String? = nil
    public var progress: ProgressItem? = nil
    public var stream: String? = nil
    public var from: String? = nil
    public var time: Date? = nil
    public var error: ProgressError? = nil
    public var aux: Data? = nil
    
    public enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case status
        case progress = "progressDetail"
        case stream
        case from
        case time
        case error
        case aux
    }
}

public struct ProgressItem: Codable, Hashable {
    
    public var current: Int? = nil
    public var total: Int? = nil
    public var start: Int? = nil
    public var hideCounts: Bool? = nil
    public var units: String? = nil
    
    public enum CodingKeys: String, CodingKey, CaseIterable {
        case current
        case total
        case start
        case hideCounts = "hidecounts"
        case units
    }
}

public struct ProgressError: Codable, Hashable {
    
    public var code: Int? = nil
    public var message: String? = nil
}

#if DEBUG
extension ProgressResponse: FileStreamPreviewable {
    public static var previewsFilename: String { "ProgressStream" }
}
#endif
