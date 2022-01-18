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
    
    private final class StreamData {
        let convertToArray: Bool
        weak var value: StreamHandlingDelegate? = nil
        var responseContinuation: CheckedContinuation<HTTPURLResponse, Error>? = nil
        
        init(_ convertToArray: Bool) {
            self.convertToArray = convertToArray
        }
    }
    
    public override init() {
        super.init()
        self.session = URLSession.shared
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        configuration.timeoutIntervalForRequest = 60 * 30 // 30 Minutes
        configuration.timeoutIntervalForResource = 60 * 30 // 30 Minutes
        self.streamSession = URLSession(configuration: configuration, delegate: self, delegateQueue: .main)
    }
    
    // MARK: - Loading Implementation
    
    internal func load<Body: Encodable, Content: Decodable>(_ request: APIRequest<Body>) async throws -> APIResponse<Content> {
        let urlRequest = try request.createURLRequest()
        let (data, response) = try await session.data(for: urlRequest)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIResponseError.unknown(nil)
        }
        return try APIResponse(data: data, response: httpResponse)
    }
    
    internal func load<Body: Encodable, Content: Decodable>(_ request: APIRequest<Body>) async throws -> Content {
        try await load(request).content
    }
    
    internal func load<Body: Encodable>(_ request: APIRequest<Body>) async throws {
        try await load(request)
    }
    
    // MARK: - Stream Implementation
    
    internal func stream<Body: Encodable, Content: Decodable>(_ request: APIRequest<Body>, convertToArray: Bool = false) async throws -> APIStreamResponse<Content> {
        let urlRequest = try request.createURLRequest()
        let task = streamSession.dataTask(with: urlRequest)
        streamData[task] = StreamData(convertToArray)
        let urlResponse = try await withCheckedThrowingContinuation({ continuation in
            streamData[task]?.responseContinuation = continuation
        })
        let response = APIStreamResponse<Content>(response: urlResponse, convertToArray: convertToArray, onTermination: { @Sendable termination in
            task.cancel()
            self.streamData.removeValue(forKey: task)
        })
        streamData[task]?.value = response
        task.resume()
        return response
    }
    
    // MARK: - URL Session Delegate
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse) async -> URLSession.ResponseDisposition {
        if let response = response as? HTTPURLResponse {
            streamData[dataTask]?.responseContinuation?.resume(returning: response)
            streamData[dataTask]?.responseContinuation = nil
        }
        return .allow
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        streamData[dataTask]?.value?.received(data)
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        streamData[task]?.value?.complete(withError: error)
        if let error = error {
            streamData[task]?.responseContinuation?.resume(throwing: error)
            streamData[task]?.responseContinuation = nil
        }
    }
}
