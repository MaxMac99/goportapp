//
//  APIResponse.swift
//  GoPortApi
//
//  Created by Max Vissing on 15.01.22.
//

import Foundation

public class APIResponse<Content> {
    var statusCode: Int
    var headers: [AnyHashable:Any]
    var content: Content
    
    init(content: Content, response: HTTPURLResponse) {
        self.statusCode = response.statusCode
        self.headers = response.allHeaderFields
        self.content = content
    }
    
    internal convenience init(data: Data, response: HTTPURLResponse, mapFunction: @escaping (Data) throws -> Content) throws {
        self.init(content: try mapFunction(data), response: response)
    }
    
    fileprivate static func checkStatusCode(_ statusCode: Int, data: Data) throws {
        guard statusCode >= 400 else { return }
        let description = String(data: data, encoding: .utf8)
        throw APIResponseError(statusCode: statusCode, description: description)
    }
}

typealias APIEmptyResponse = APIResponse<Data>
