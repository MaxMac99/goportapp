//
//  APIPathProtocol.swift
//  GoPortApi
//
//  Created by Max Vissing on 15.01.22.
//

import Foundation

public enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case HEAD = "HEAD"
    case PUT = "PUT"
    case DELETE = "DELETE"
}

internal protocol APIPathProtocol {
    var path: String { get }
}

internal extension APIPathProtocol {
    func mapToPathItem(_ source: Any) -> String {
        let escaped = "\(mapValueToPathItem(source))"
        return escaped.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
    }
    
    private func mapValueToPathItem(_ source: Any) -> Any {
        if let collection = source as? [Any?] {
            return collection.filter { $0 != nil }.map { "\($0!)" }.joined(separator: ",")
        }
        return source
    }
}
