//
//  SystemPingResponse.swift
//  GoPortApi
//
//  Created by Max Vissing on 14.01.22.
//

import Foundation

public typealias SystemPingResponse = [String: SystemPingResponseItem]

public struct SystemPingResponseSummary {
    public var goportVersion: String?
    public var contexts: SystemPingResponse
}
