//
//  PreviewNetworkingSession.swift
//  GoPortApi
//
//  Created by Max Vissing on 14.01.22.
//

import Foundation

public class PreviewNetworkingSession: NetworkingSession {
    internal override func load(from host: URL, on path: String, via method: HTTPMethod, with query: [URLQueryItem], body: Data?) async throws -> (data: Data, response: HTTPURLResponse) {
        guard let request = createRequest(from: host, on: path, via: method, with: query, body: body), let url = request.url else {
            throw APIError.invalidURL(host.absoluteString + path)
        }
        var headerFields: [String: String]?
        if path == "/_ping" {
            if method == .HEAD {
                headerFields = try! JSONDecoder().decode([String:String].self, from: try! JSONEncoder().encode(SystemPingHeader.preview))
            } else {
                headerFields = ["Goport-Version": "v1"]
            }
        }
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "2.0", headerFields: headerFields)!
        return (data: try dataForPath(path, with: method), response: response)
    }
    
    internal override func stream(from host: URL, on path: String, via method: HTTPMethod, hasJSONResponse: Bool, convertArray: Bool, with query: [URLQueryItem], body: Data?) async throws -> (stream: AsyncThrowingStream<Data, Error>, response: HTTPURLResponse) {
        guard let request = createRequest(from: host, on: path, via: method, with: query, body: body), let url = request.url else {
            throw APIError.invalidURL(host.absoluteString + path)
        }
        let stream = AsyncThrowingStream<Data, Error> { continuation in
            continuation.finish(throwing: nil)
        }
        return (stream: stream, response: HTTPURLResponse(url: url, statusCode: 200, httpVersion: "2.0", headerFields: nil)!)
    }
    
    private func dataForPath(_ path: String, with method: HTTPMethod) throws -> Data {
        print("\(method) for path \(path)")
        let components = Array(path.components(separatedBy: "/").dropFirst())
        switch components.first {
        case "contexts":
            if let mockData = try ContextsMockData.mockDataForPath(components: Array(components.dropFirst()), with: dockerEncoder, method: method) {
                return mockData
            }
        default:
            if let mockData = try SystemMockData.mockDataForPath(components: components, with: dockerEncoder, method: method) {
                return mockData
            }
        }
        return Data()
    }
}

public extension NetworkingSession {
    static var preview: PreviewNetworkingSession {
        PreviewNetworkingSession()
    }
}
