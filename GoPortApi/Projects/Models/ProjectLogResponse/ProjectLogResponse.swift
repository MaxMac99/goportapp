//
//  ProjectLogResponse.swift
//  GoPortApi
//
//  Created by Max Vissing on 28.01.22.
//

import Foundation

public typealias ProjectLogResponse = [ProjectLogItem]

public struct ProjectLogItem: Codable, Hashable {
    
    public var log: ProjectLogMessage? = nil
    public var status: ProjectLogStatus? = nil
    public var register: ProjectLogRegister? = nil
    
    public enum CodingKeys: String, CodingKey, CaseIterable {
        case log = "Log"
        case status = "Status"
        case register = "Register"
    }
}

#if DEBUG
extension ProjectLogItem: FileStreamPreviewable {
    public static var previewsFilename: String { "ProjectLogsStreamResponse" }
}

extension ProjectLogItem: FilePreviewableAsArray {
    public static var previewFilename: String { "ProjectLogsResponse" }
}
#endif
