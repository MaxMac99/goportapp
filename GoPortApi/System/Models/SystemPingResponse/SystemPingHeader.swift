//
//  PingHeaderInformation.swift
//  GoPortApi
//
//  Created by Max Vissing on 09.01.22.
//

import Foundation

public struct SystemPingHeader: Codable, Hashable {
    
    public var apiVersion: String?
    public var goportVersion: String?
    public var osType: String?
    public var dockerExperimental: String?
    
    public enum CodingKeys: String, CodingKey, CaseIterable {
        case apiVersion = "Api-Version"
        case goportVersion = "Goport-Version"
        case osType = "Ostype"
        case dockerExperimental = "Docker-Experimental"
    }
    
    public init(_ headers: [AnyHashable: Any]) throws {
        self = try JSONDecoder().decode(SystemPingHeader.self, from: JSONSerialization.data(withJSONObject: headers))
    }
}

#if DEBUG
extension SystemPingHeader {
    internal static var previewFilename: String { "ping.header" }
    public static var preview: SystemPingHeader {
        get throws {
            try SystemPingHeader(try MockHelper.loadHeaders(previewFilename))
        }
    }
}
#endif
