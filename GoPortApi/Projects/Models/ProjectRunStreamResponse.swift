//
//  ProjectRunResponse.swift
//  GoPortApi
//
//  Created by Max Vissing on 28.01.22.
//

import Foundation

public struct ProjectRunStreamResponse: Codable {
    
    public var stdout: String? = nil
    public var stderr: String? = nil
    public var returnCode: Int? = nil
    public var error: String? = nil
    
    public enum CodingKeys: String, CodingKey, CaseIterable {
        case stdout
        case stderr
        case returnCode
        case error
    }
}

#if DEBUG
extension ProjectRunStreamResponse: FileStreamPreviewable {
    public static var previewsFilename: String { "ProjectRunStreamResponse" }
}
#endif
