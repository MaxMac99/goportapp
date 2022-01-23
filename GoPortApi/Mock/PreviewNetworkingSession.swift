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
            return try await handleExceptions(request)
        }
        let type = Content.self as! Previewable.Type
        let preview = type.preview as! Content
        return APIResponse(content: preview, response: try successfulHTTPURLResponse(for: request))
    }
    
    override func stream<Body, Content>(_ request: APIRequest<Body>, convertToArray: Bool = false) async throws -> APIStreamResponse<Content> where Body : Encodable, Content : Decodable {
        if Content.self is StreamPreviewable.Type {
            return try await streamStreamPreviewable(request, convertToArray: convertToArray)
        }
        if Content.self is Previewable.Type {
            return try await streamPreviewable(request, convertToArray: convertToArray)
        }
        throw PreviewNetworkingError.notImplemented
    }
    
    private func streamPreviewable<Body, Content>(_ request: APIRequest<Body>, convertToArray: Bool = false) async throws -> APIStreamResponse<Content> where Body : Encodable, Content : Decodable {
        guard Content.self is Previewable.Type else {
            throw PreviewNetworkingError.notImplemented
        }
        
        let type = Content.self as! Previewable.Type
        let preview = try type.preview.asData
        let response = APIStreamResponse<Content>(response: try successfulHTTPURLResponse(for: request), convertToArray: convertToArray, onTermination: nil)
        
        Task { [weak response] in
            for _ in 0..<5 {
                try await Task.sleep(nanoseconds: 200_000)
                response?.received(preview + "\n".utf8)
            }
            response?.complete(withError: nil)
        }
        return response
    }
    
    private func streamStreamPreviewable<Body, Content>(_ request: APIRequest<Body>, convertToArray: Bool = false) async throws -> APIStreamResponse<Content> where Body : Encodable, Content : Decodable {
        guard Content.self is StreamPreviewable.Type else {
            throw PreviewNetworkingError.notImplemented
        }
        
        let type = Content.self as! StreamPreviewable.Type
        let response = APIStreamResponse<Content>(response: try successfulHTTPURLResponse(for: request), convertToArray: convertToArray, onTermination: nil)
        
        Task { [weak response] in
            for preview in type.previews {
                try await Task.sleep(nanoseconds: 200_000)
                response?.received(try preview.asData + "\n".utf8)
            }
            response?.complete(withError: nil)
        }
        return response
    }
    
    private func handleExceptions<Body, Content>(_ request: APIRequest<Body>) async throws -> APIResponse<Content> where Body: Encodable {
        switch request.path {
        case NetworkAPI.NetworkAPIPath.networkList:
            return APIResponse(content: NetworkListResponse.preview as! Content, response: try successfulHTTPURLResponse(for: request))
        default:
            throw PreviewNetworkingError.notImplemented
        }
    }
}

internal enum PreviewNetworkingError: Error {
    case notImplemented
}

public extension NetworkingSession {
    static let preview: NetworkingSession = PreviewNetworkingSession()
}
