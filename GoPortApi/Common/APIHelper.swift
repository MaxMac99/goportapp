//
//  HTTPMethod.swift
//  GoPortApi
//
//  Created by Max Vissing on 28.12.21.
//

import Foundation

public enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case HEAD = "HEAD"
    case PUT = "PUT"
    case DELETE = "DELETE"
}

public enum APIHelper {
    
    public static func mapToPathItem(_ source: Any) -> String {
        let escaped = "\(mapValueToPathItem(source))"
        return escaped.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
    }
    
    public static func mapValuesToQueryItems(_ source: [String: Any?]) -> [URLQueryItem] {
        let destination = source.filter { $0.value != nil }.reduce(into: [URLQueryItem]()) { result, item in
            if let collection = item.value as? [Any?] {
                collection.filter { $0 != nil }.map { "\($0!)" }.forEach { value in
                    result.append(URLQueryItem(name: item.key, value: value))
                }
            } else if let value = item.value {
                result.append(URLQueryItem(name: item.key, value: "\(value)"))
            }
        }
        
        if destination.isEmpty {
            return []
        }
        return destination
    }
    
    private static func mapValueToPathItem(_ source: Any) -> Any {
        if let collection = source as? [Any?] {
            return collection.filter { $0 != nil }.map { "\($0!)" }.joined(separator: ",")
        }
        return source
    }
}
