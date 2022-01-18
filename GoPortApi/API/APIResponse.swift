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
    
    fileprivate static func checkStatusCode(_ statusCode: Int, data: Data) throws {
        guard statusCode >= 400 else { return }
        let description = String(data: data, encoding: .utf8)
        throw APIResponseError(statusCode: statusCode, description: description)
    }
}

public typealias APIEmptyResponse = APIResponse<Data>

public extension APIResponse where Content: Decodable {
    convenience init(data: Data, response: HTTPURLResponse) throws {
        try APIResponse.checkStatusCode(response.statusCode, data: data)
        let content = try dockerDecoder.decode(Content.self, from: data)
        self.init(content: content, response: response)
    }
}

public extension APIResponse where Content == String {
    convenience init(data: Data, response: HTTPURLResponse) throws {
        try APIResponse.checkStatusCode(response.statusCode, data: data)
        guard let content = String(data: data, encoding: .utf8) else {
            throw APIResponseError.unknown(nil)
        }
        self.init(content: content, response: response)
    }
}

public extension APIResponse where Content == Data {
    convenience init(data: Data, response: HTTPURLResponse) throws {
        try APIResponse.checkStatusCode(response.statusCode, data: data)
        self.init(content: data, response: response)
    }
}
