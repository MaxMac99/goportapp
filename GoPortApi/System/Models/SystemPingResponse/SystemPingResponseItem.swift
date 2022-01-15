//
//  SystemPingResponse.swift
//  GoPortApi
//
//  Created by Max Vissing on 14.01.22.
//

import Foundation

public struct SystemPingResponseItem: Codable, Hashable {
    
    public var apiVersion: String?
    public var osType: String?
    public var dockerExperimental: String?
    public var error: String?
    
    public enum CodingKeys: String, CodingKey, CaseIterable {
        case apiVersion = "APIVersion"
        case osType = "OSType"
        case dockerExperimental = "Experimental"
        case error = "Error"
    }
}
