//
//  PreviewNetworkingSession.swift
//  GoPortApi
//
//  Created by Max Vissing on 14.01.22.
//

import Foundation

internal class PreviewNetworkingSession: NetworkingSession {
    func successfulHTTPURLResponse<Body>(for request: APIRequest<Body>) throws -> HTTPURLResponse {
        let urlRequest = try request.createURLRequest()
        let headerFields = ["Goport-Version":"v1"]
        return HTTPURLResponse(url: urlRequest.url!, statusCode: 200, httpVersion: nil, headerFields: headerFields)!
    }
    
    override func load<Body, Content>(_ request: APIRequest<Body>) async throws -> APIResponse<Content> where Body : Encodable {
        guard Content.self is Previewable.Type else {
            throw PreviewNetworkingError.notImplemented
        }
        let type = Content.self as! Previewable.Type
        let preview = type.preview as! Content
        return APIResponse(content: preview, response: try successfulHTTPURLResponse(for: request))
    }
    
    override func stream<Body, Content>(_ request: APIRequest<Body>, convertToArray: Bool = false) async throws -> APIStreamResponse<Content> where Body : Encodable, Content : Decodable {
        guard Content.self is Previewable.Type else {
            throw PreviewNetworkingError.notImplemented
        }
        
        let type = Content.self as! Previewable.Type
        let preview = try type.preview.asData
        let response = APIStreamResponse<Content>(response: try successfulHTTPURLResponse(for: request), convertToArray: convertToArray, onTermination: nil)
        
        Task { [weak response] in
            for _ in 0..<5 {
                try await Task.sleep(nanoseconds: 200000)
                response?.received(preview + "\n".utf8)
            }
            response?.complete(withError: nil)
        }
        return response
    }
}

internal enum PreviewNetworkingError: Error {
    case notImplemented
}

public extension NetworkingSession {
    static let preview: NetworkingSession = PreviewNetworkingSession()
}
