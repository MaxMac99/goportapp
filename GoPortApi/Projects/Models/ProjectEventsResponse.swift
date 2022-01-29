//
//  ProjectEventsResponse.swift
//  GoPortApi
//
//  Created by Max Vissing on 27.01.22.
//

import Foundation

public struct ProjectEventResponseItem: Codable, Hashable {
    public var timestamp: Date? = nil
    public var service: String? = nil
    public var container: String? = nil
    public var status: String? = nil
    public var attributes: [String:String]? = nil
}

#if DEBUG
extension ProjectEventResponseItem: FileStreamPreviewable {
    public static var previewsFilename: String { "ProjectEventsStreamResponse" }
}
#endif
