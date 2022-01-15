//
//  NetworkingSession.swift
//  GoPortApi
//
//  Created by Max Vissing on 28.12.21.
//

import Foundation

public class NetworkingSession: NSObject, URLSessionDataDelegate {
    public static let shared = NetworkingSession()
    
    private var session: URLSession! = nil
    private var streamSession: URLSession! = nil
    private var streamData: [URLSessionTask:StreamData] = [:]
    
    private struct StreamData {
        var responseStream: AsyncThrowingStream<Data, Error>.Continuation? = nil
        var response: CheckedContinuation<HTTPURLResponse, Error>? = nil
        var cache: Data? = nil
        var cacheEnabled: Bool = false
        var convertArray: Bool = false
    }
    
    public override init() {
        super.init()
        self.session = URLSession.shared
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60 * 30 // 30 mins
        self.streamSession = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }
    
    // MARK: - Loading Implementation
    
    internal func load(from host: URL, on path: String, via method: HTTPMethod = .GET, with query: [URLQueryItem] = [], body: Data? = nil) async throws -> (data: Data, response: HTTPURLResponse) {
        guard let request = createRequest(from: host, on: path, via: method, with: query, body: body) else {
            throw APIError.invalidURL(host.absoluteString + path)
        }
        print("Request: \(request)")
        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.noHTTPResponse
        }
        return (data, httpResponse)
    }
    
    internal func run(from host: URL, on path: String, via method: HTTPMethod = .GET, with query: [URLQueryItem] = [], body: Data? = nil) async throws {
        let (_, _) = try await load(from: host, on: path, via: method, with: query, body: body)
    }
    
    internal func load(from host: URL, on path: String, via method: HTTPMethod = .GET, with query: [URLQueryItem] = [], body: Data? = nil) async throws -> HTTPURLResponse {
        try await load(from: host, on: path, via: method, with: query, body: body).response
    }
    
    internal func load<Response: Decodable>(from host: URL, on path: String, via method: HTTPMethod = .GET, with query: [URLQueryItem] = [], body: Data? = nil) async throws -> (item: Response, response: HTTPURLResponse) {
        let (data, response) = try await load(from: host, on: path, via: method, with: query, body: body)
        print("Response<\(Response.self)>: \(String(data: data, encoding: .utf8)!)")
        return (try dockerDecoder.decode(Response.self, from: data), response)
    }
    
    internal func load<Response: Decodable>(from host: URL, on path: String, via method: HTTPMethod = .GET, with query: [URLQueryItem] = [], body: Data? = nil) async throws -> Response {
        try await load(from: host, on: path, via: method, with: query, body: body).item
    }
    
    // Same with Request item
    internal func load<Request: Encodable>(from host: URL, on path: String, via method: HTTPMethod = .GET, with query: [URLQueryItem] = [], item: Request? = nil) async throws -> (data: Data, response: HTTPURLResponse) {
        let body = try dockerEncoder.encode(item)
        return try await load(from: host, on: path, via: method, with: query, body: body)
    }
    
    internal func run<Request: Encodable>(from host: URL, on path: String, via method: HTTPMethod = .GET, with query: [URLQueryItem] = [], item: Request? = nil) async throws {
        let (_, _) = try await load(from: host, on: path, via: method, with: query, item: item)
    }
    
    internal func load<Request: Encodable>(from host: URL, on path: String, via method: HTTPMethod = .GET, with query: [URLQueryItem] = [], item: Request? = nil) async throws -> HTTPURLResponse {
        let body = try dockerEncoder.encode(item)
        return try await load(from: host, on: path, via: method, with: query, body: body)
    }
    
    internal func load<Request: Encodable, Response: Decodable>(from host: URL, on path: String, via method: HTTPMethod = .GET, with query: [URLQueryItem] = [], item: Request? = nil) async throws -> (item: Response, response: HTTPURLResponse) {
        let body = try dockerEncoder.encode(item)
        return try await load(from: host, on: path, via: method, with: query, body: body)
    }
    
    internal func load<Request: Encodable, Response: Decodable>(from host: URL, on path: String, via method: HTTPMethod = .GET, with query: [URLQueryItem] = [], item: Request? = nil) async throws -> Response {
        let body = try dockerEncoder.encode(item)
        return try await load(from: host, on: path, via: method, with: query, body: body)
    }
    
    
    // MARK: - Stream Implementation
    
    internal func stream(from host: URL, on path: String, via method: HTTPMethod = .GET, hasJSONResponse: Bool, convertArray: Bool = false, with query: [URLQueryItem] = [], body: Data? = nil) async throws -> (stream: AsyncThrowingStream<Data, Error>, response: HTTPURLResponse) {
        guard let request = createRequest(from: host, on: path, via: method, with: query, body: body) else {
            throw APIError.invalidURL(host.absoluteString + path)
        }
        let task = streamSession.dataTask(with: request)
        streamData[task] = StreamData(cacheEnabled: hasJSONResponse, convertArray: convertArray)
        let stream = AsyncThrowingStream<Data, Error> { continuation in
            streamData[task]!.responseStream = continuation
        }
        task.resume()
        let response = try await withCheckedThrowingContinuation({ continuation in
            streamData[task]?.response = continuation
        })
        return (stream, response)
    }
    
    internal func stream<Response: Decodable>(from host: URL, on path: String, via method: HTTPMethod = .GET, hasJSONResponse: Bool = true, convertArray: Bool = false, with query: [URLQueryItem] = [], body: Data? = nil) async throws -> (stream: AsyncThrowingMapSequence<AsyncThrowingStream<Data, Error>, Response>, response: HTTPURLResponse) {
        let (stream, response) = try await stream(from: host, on: path, via: method, hasJSONResponse: hasJSONResponse, convertArray: convertArray, with: query, body: body)
        return (stream.map({ data in
            return try dockerDecoder.decode(Response.self, from: data)
        }), response)
    }
    
    internal func stream<Response: Decodable>(from host: URL, on path: String, via method: HTTPMethod = .GET, hasJSONResponse: Bool = true, convertArray: Bool = false, with query: [URLQueryItem] = [], body: Data? = nil) async throws -> AsyncThrowingMapSequence<AsyncThrowingStream<Data, Error>, Response> {
        try await stream(from: host, on: path, via: method, hasJSONResponse: hasJSONResponse, convertArray: convertArray, with: query, body: body).stream
    }
    
    // Same with Request item
    
    internal func stream<Request: Encodable>(from host: URL, on path: String, via method: HTTPMethod = .GET, hasJSONResponse: Bool = true, convertArray: Bool = false, with query: [URLQueryItem] = [], item: Request? = nil) async throws -> (stream: AsyncThrowingStream<Data, Error>, response: HTTPURLResponse) {
        let body = try dockerEncoder.encode(item)
        return try await stream(from: host, on: path, via: method, hasJSONResponse: hasJSONResponse, convertArray: convertArray, with: query, body: body)
    }
    
    internal func stream<Request: Encodable, Response: Decodable>(from host: URL, on path: String, via method: HTTPMethod = .GET, hasJSONResponse: Bool = true, convertArray: Bool = false, with query: [URLQueryItem] = [], item: Request? = nil) async throws -> (stream: AsyncThrowingMapSequence<AsyncThrowingStream<Data, Error>, Response>, response: HTTPURLResponse) {
        let body = try dockerEncoder.encode(item)
        return try await stream(from: host, on: path, via: method, hasJSONResponse: hasJSONResponse, convertArray: convertArray, with: query, body: body)
    }
    
    internal func stream<Request: Encodable, Response: Decodable>(from host: URL, on path: String, via method: HTTPMethod = .GET, hasJSONResponse: Bool = true, convertArray: Bool = false, with query: [URLQueryItem] = [], item: Request? = nil) async throws -> AsyncThrowingMapSequence<AsyncThrowingStream<Data, Error>, Response> {
        let body = try dockerEncoder.encode(item)
        return try await stream(from: host, on: path, via: method, hasJSONResponse: hasJSONResponse, convertArray: convertArray, with: query, body: body).stream
    }
    
    // MARK: - Helper
    
    internal func createRequest(from host: URL, on path: String, via method: HTTPMethod = .GET, with query: [URLQueryItem] = [], body: Data? = nil) -> URLRequest? {
        var fullHost = host
        if host.scheme != "http" || host.scheme != "https" {
            guard let tempFullHost = URL(string: "http://\(host.absoluteString)") else { return nil }
            fullHost = tempFullHost
        }
        let hostWithComp = fullHost.appendingPathComponent(path)
        guard var urlComponents = URLComponents(url: hostWithComp, resolvingAgainstBaseURL: true) else { return nil }
        urlComponents.queryItems = query
        if hostWithComp.port == nil {
            urlComponents.port = GoPort.DEFAULT_PORT
        }
        guard let url = urlComponents.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        return request
    }
    
    // MARK: - URL Session Delegate
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        guard let response = response as? HTTPURLResponse else { return }
        streamData[dataTask]?.response?.resume(returning: response)
        streamData[dataTask]?.response = nil
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        guard let stream = streamData[dataTask] else {
            return
        }
        
        var newData = data
        if stream.convertArray, var converted = String(data: newData, encoding: .utf8) {
            converted = converted.replacingOccurrences(of: "\r\n", with: ",")
            converted = "[\(converted)]"
            newData = converted.data(using: .utf8)!
        }
        
        var completeData = newData
        if stream.cacheEnabled && !stream.convertArray {
            if let previousData = stream.cache, newData.first != UInt8(String("{").utf8.first!) {
                completeData = previousData
                completeData.append(newData)
            }
            
            if let newlinePos = completeData.firstIndex(of: UInt8(String("\n").utf8.first!)) {
                if newlinePos != completeData.count-1 {
                    let restData = completeData.subdata(in: newlinePos+1..<completeData.count)
                    streamData[dataTask]!.cache = restData
                }
                completeData = completeData.subdata(in: 0..<newlinePos)
            } else {
                streamData[dataTask]!.cache = completeData
                return
            }
        }
        stream.responseStream?.yield(completeData)
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        var handler = streamData.removeValue(forKey: task)
        handler?.responseStream?.finish(throwing: error)
        
        if let error = error {
            handler?.response?.resume(throwing: error)
            handler?.response = nil
        }
    }
}
