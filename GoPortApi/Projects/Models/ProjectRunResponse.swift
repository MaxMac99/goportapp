//
//  ProjectRunResponse.swift
//  GoPortApi
//
//  Created by Max Vissing on 28.01.22.
//

import Foundation

public struct ProjectRunResponse: Codable {
    
    public var containerId: String? = nil
    public var returnCode: Int? = nil
    public var error: String? = nil
    
}

#if DEBUG
extension ProjectRunResponse: FilePreviewable {
    public static var previewFilename: String { "ProjectRunResponse" }
}
#endif
