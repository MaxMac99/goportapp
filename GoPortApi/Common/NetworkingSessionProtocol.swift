//
//  NetworkingSessionType.swift
//  GoPortApi
//
//  Created by Max Vissing on 28.12.21.
//

import Foundation

fileprivate let DEFAULT_PORT = 9212
fileprivate let GOPORT_VERSION = "v1"

public protocol NetworkingSessionProtocol {
    func load(from host: URL, on path: String, via method: HTTPMethod, with query: [URLQueryItem], body: Data?) async throws -> (data: Data, response: HTTPURLResponse)
    
    func stream(from host: URL, on path: String, via method: HTTPMethod, hasJSONResponse: Bool, convertArray: Bool, with query: [URLQueryItem], body: Data?) async throws -> (stream: AsyncThrowingStream<Data, Error>, response: HTTPURLResponse)
}

extension NetworkingSessionProtocol {
    
    public func load(from host: URL, on path: String, via method: HTTPMethod = .GET, with query: [URLQueryItem] = [], body: Data? = nil) async throws -> (data: Data, response: HTTPURLResponse) {
        try await load(from: host, on: path, via: method, with: query, body: body)
    }
    
    public func load(from host: URL, on path: String, via method: HTTPMethod = .GET, with query: [URLQueryItem] = [], body: Data? = nil) async throws -> HTTPURLResponse {
        try await load(from: host, on: path, via: method, with: query, body: body).response
    }
    
    public func load(from host: URL, on path: String, via method: HTTPMethod = .GET, with query: [URLQueryItem] = [], body: Data? = nil) async throws {
        _ = try await load(from: host, on: path, via: method, with: query, body: body)
    }
    
    public func load<Response: Decodable>(from host: URL, on path: String, via method: HTTPMethod = .GET, with query: [URLQueryItem] = [], body: Data? = nil) async throws -> (item: Response, response: HTTPURLResponse) {
        let (data, response) = try await load(from: host, on: path, via: method, with: query, body: body)
        return (try dockerDecoder.decode(Response.self, from: data), response)
    }
    
    public func load<Response: Decodable>(from host: URL, on path: String, via method: HTTPMethod = .GET, with query: [URLQueryItem] = [], body: Data? = nil) async throws -> Response {
        try await load(from: host, on: path, via: method, with: query, body: body).item
    }
    
    // Same with Request item
    
    public func load<Request: Encodable>(from host: URL, on path: String, via method: HTTPMethod = .GET, with query: [URLQueryItem] = [], item: Request? = nil) async throws -> (data: Data, response: HTTPURLResponse) {
        let body = try dockerEncoder.encode(item)
        return try await load(from: host, on: path, via: method, with: query, body: body)
    }
    
    public func load<Request: Encodable>(from host: URL, on path: String, via method: HTTPMethod = .GET, with query: [URLQueryItem] = [], item: Request? = nil) async throws -> HTTPURLResponse {
        let body = try dockerEncoder.encode(item)
        return try await load(from: host, on: path, via: method, with: query, body: body)
    }
    
    public func load<Request: Encodable>(from host: URL, on path: String, via method: HTTPMethod = .GET, with query: [URLQueryItem] = [], item: Request? = nil) async throws {
        let body = try dockerEncoder.encode(item)
        _ = try await load(from: host, on: path, via: method, with: query, body: body)
    }
    
    public func load<Request: Encodable, Response: Decodable>(from host: URL, on path: String, via method: HTTPMethod = .GET, with query: [URLQueryItem] = [], item: Request? = nil) async throws -> (item: Response, response: HTTPURLResponse) {
        let body = try dockerEncoder.encode(item)
        return try await load(from: host, on: path, via: method, with: query, body: body)
    }
    
    public func load<Request: Encodable, Response: Decodable>(from host: URL, on path: String, via method: HTTPMethod = .GET, with query: [URLQueryItem] = [], item: Request? = nil) async throws -> Response {
        let body = try dockerEncoder.encode(item)
        return try await load(from: host, on: path, via: method, with: query, body: body)
    }
    
    // Stream
    
    public func stream(from host: URL, on path: String, via method: HTTPMethod = .GET, hasJSONResponse: Bool, convertArray: Bool = false, with query: [URLQueryItem] = [], body: Data? = nil) async throws -> (stream: AsyncThrowingStream<Data, Error>, response: HTTPURLResponse) {
        try await stream(from: host, on: path, via: method, hasJSONResponse: hasJSONResponse, convertArray: convertArray, with: query, body: body)
    }
    
    public func stream<Response: Decodable>(from host: URL, on path: String, via method: HTTPMethod = .GET, hasJSONResponse: Bool = true, convertArray: Bool = false, with query: [URLQueryItem] = [], body: Data? = nil) async throws -> (stream: AsyncThrowingMapSequence<AsyncThrowingStream<Data, Error>, Response>, response: HTTPURLResponse) {
        let (stream, response) = try await stream(from: host, on: path, via: method, hasJSONResponse: hasJSONResponse, convertArray: convertArray, with: query, body: body)
        return (stream.map({ data in
            return try dockerDecoder.decode(Response.self, from: data)
        }), response)
    }
    
    public func stream<Response: Decodable>(from host: URL, on path: String, via method: HTTPMethod = .GET, hasJSONResponse: Bool = true, convertArray: Bool = false, with query: [URLQueryItem] = [], body: Data? = nil) async throws -> AsyncThrowingMapSequence<AsyncThrowingStream<Data, Error>, Response> {
        try await stream(from: host, on: path, via: method, hasJSONResponse: hasJSONResponse, convertArray: convertArray, with: query, body: body).stream.map({ data in
            return try dockerDecoder.decode(Response.self, from: data)
        })
    }
    
    // Same with Request item
    
    public func stream<Request: Encodable>(from host: URL, on path: String, via method: HTTPMethod = .GET, hasJSONResponse: Bool = true, convertArray: Bool = false, with query: [URLQueryItem] = [], item: Request? = nil) async throws -> (stream: AsyncThrowingStream<Data, Error>, response: HTTPURLResponse) {
        let body = try dockerEncoder.encode(item)
        return try await stream(from: host, on: path, via: method, hasJSONResponse: hasJSONResponse, convertArray: convertArray, with: query, body: body)
    }
    
    public func stream<Request: Encodable, Response: Decodable>(from host: URL, on path: String, via method: HTTPMethod = .GET, hasJSONResponse: Bool = true, convertArray: Bool = false, with query: [URLQueryItem] = [], item: Request? = nil) async throws -> (stream: AsyncThrowingMapSequence<AsyncThrowingStream<Data, Error>, Response>, response: HTTPURLResponse) {
        let body = try dockerEncoder.encode(item)
        return try await stream(from: host, on: path, via: method, hasJSONResponse: hasJSONResponse, convertArray: convertArray, with: query, body: body)
    }
    
    public func stream<Request: Encodable, Response: Decodable>(from host: URL, on path: String, via method: HTTPMethod = .GET, hasJSONResponse: Bool = true, convertArray: Bool = false, with query: [URLQueryItem] = [], item: Request? = nil) async throws -> AsyncThrowingMapSequence<AsyncThrowingStream<Data, Error>, Response> {
        let body = try dockerEncoder.encode(item)
        return try await stream(from: host, on: path, via: method, hasJSONResponse: hasJSONResponse, convertArray: convertArray, with: query, body: body)
    }
    
    // MARK: - Helper
    
    internal func createRequest(from host: URL, on path: String, via method: HTTPMethod = .GET, with query: [URLQueryItem] = [], body: Data? = nil) -> URLRequest? {
        var fullHost = host
        if host.scheme != "http" || host.scheme != "https" {
            guard let tempFullHost = URL(string: "http://\(host.absoluteString)") else { return nil }
            fullHost = tempFullHost
        }
        let hostWithComp = fullHost.appendingPathComponent(GOPORT_VERSION).appendingPathComponent(path)
        guard var urlComponents = URLComponents(url: hostWithComp, resolvingAgainstBaseURL: true) else { return nil }
        urlComponents.queryItems = query
        if hostWithComp.port == nil {
            urlComponents.port = DEFAULT_PORT
        }
        guard let url = urlComponents.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        return request
    }
}
