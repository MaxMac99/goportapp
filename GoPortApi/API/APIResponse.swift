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
    
    internal convenience init(data: Data, response: HTTPURLResponse) throws {
        throw DataConvertibleError.notImplemented
    }
    
    fileprivate static func checkStatusCode(_ statusCode: Int, data: Data) throws {
        guard statusCode >= 400 else { return }
        let description = String(data: data, encoding: .utf8)
        throw APIResponseError(statusCode: statusCode, description: description)
    }
}

typealias APIEmptyResponse = APIResponse<Data>

extension APIResponse where Content == Data {
    convenience init(data: Data, response: HTTPURLResponse) throws {
        self.init(content: data, response: response)
    }
}

extension APIResponse where Content == String {
    convenience init(data: Data, response: HTTPURLResponse) throws {
        guard let string = String(data: data, encoding: .utf8) else {
            throw DataConvertibleError.invalidResponse
        }
        self.init(content: string, response: response)
    }
}

extension APIResponse where Content: Decodable {
    convenience init(data: Data, response: HTTPURLResponse) throws {
        self.init(content: try dockerDecoder.decode(Content.self, from: data), response: response)
    }
}

extension APIResponse where Content: DataConvertible {
    convenience init(data: Data, response: HTTPURLResponse) throws {
        self.init(content: try Content.convert(data), response: response)
    }
}
