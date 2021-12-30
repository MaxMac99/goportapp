//
//  NetworkingSession.swift
//  GoPortApi
//
//  Created by Max Vissing on 28.12.21.
//

import Foundation

public class NetworkingSession: NSObject, URLSessionDataDelegate, NetworkingSessionProtocol {
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
    
    // MARK: - Default Networking Operations
    
    public func load(from host: URL, on path: String, via method: HTTPMethod, with query: [URLQueryItem], body: Data?) async throws -> (data: Data, response: HTTPURLResponse) {
        guard let request = createRequest(from: host, on: path, via: method, with: query, body: body) else {
            throw APIError.invalidURLError(host.absoluteString + path)
        }
        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.noHTTPResponse
        }
        return (data, httpResponse)
    }
    
    public func stream(from host: URL, on path: String, via method: HTTPMethod, hasJSONResponse: Bool, convertArray: Bool, with query: [URLQueryItem], body: Data?) async throws -> (stream: AsyncThrowingStream<Data, Error>, response: HTTPURLResponse) {
        guard let request = createRequest(from: host, on: path, via: method, with: query, body: body) else {
            throw APIError.invalidURLError(host.absoluteString + path)
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
