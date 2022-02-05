//
//  ProjectSummary.swift
//  GoPortApi
//
//  Created by Max Vissing on 28.01.22.
//

import Foundation

public struct ProjectSummary: Identifiable, Codable {
    
    public var id: String
    public var name: String
    public var status: String? = nil
    
    public enum CodingKeys: String, CodingKey, CaseIterable {
        case id = "Id"
        case name = "Name"
        case status = "Status"
    }
}

#if DEBUG
extension ProjectSummary {
    public static let previews: [ProjectSummary] = {
        ProjectListResponse.preview.remote.first!.value
    }()
}
#endif
