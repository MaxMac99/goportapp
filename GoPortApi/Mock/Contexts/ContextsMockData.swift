//
//  ContextsMockData.swift
//  GoPortApi
//
//  Created by Max Vissing on 14.01.22.
//

import Foundation

internal struct ContextsMockData {
    internal static func mockDataForPath(components: [String], with encoder: JSONEncoder, method: HTTPMethod) throws -> Data? {
        if components.first == "json", method == .GET {
            return try encoder.encode(ContextSummary.preview)
        }
        if components.count >= 2, components[1] == "json", method == .GET {
            return try encoder.encode(ContextInspectResponse.preview)
        }
        return nil
    }
}

public extension ContextSummary {
    static var previewFile: String { "contextsList" }
    static var preview: [ContextSummary] {
        try! MockHelper.load(previewFile)
    }
}

public extension ContextInspectResponse {
    static var previewFile: String { "contextInspect" }
    static var preview: ContextInspectResponse {
        try! MockHelper.load(previewFile)
    }
}
