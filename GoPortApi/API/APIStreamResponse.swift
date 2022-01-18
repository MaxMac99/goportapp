//
//  APIStreamResponse.swift
//  GoPortApi
//
//  Created by Max Vissing on 16.01.22.
//

import Foundation

internal protocol StreamHandlingDelegate: AnyObject {
    func received(_ data: Data)
    func complete(withError error: Error?)
}

public class APIStreamResponse<Content: Decodable>: StreamHandlingDelegate {
    public var statusCode: Int
    public var headers: [AnyHashable:Any]
    public private(set) var stream: AsyncThrowingMapSequence<AsyncThrowingStream<Data, Error>, Content>

    internal var isJSONObject: Bool { true } // Should be overrideable by extensions
    
    private let convertToArray: Bool
    
    private var responseStreamContinuation: AsyncThrowingStream<Data, Error>.Continuation? = nil
    private var cache: Data? = nil
    private var onTermination: (@Sendable (AsyncThrowingStream<Data, Error>.Continuation.Termination) -> Void)?
    
    internal init(response: HTTPURLResponse, convertToArray: Bool = false, onTermination: (@Sendable (AsyncThrowingStream<Data, Error>.Continuation.Termination) -> Void)? = nil) {
        self.statusCode = response.statusCode
        self.headers = response.allHeaderFields
        self.convertToArray = convertToArray
        self.onTermination = onTermination
        self.stream = AsyncThrowingStream<Data, Error> { _ in }
        .map({ try APIStreamResponse<Content>.mapData($0) })
        
        // Can reference to self in a closure only if everything is initialized. A little bit hacky but it works.
        self.stream = AsyncThrowingStream<Data, Error> { continuation in
            self.responseStreamContinuation = continuation
            self.responseStreamContinuation?.onTermination = onTermination
        }
        .map({ try APIStreamResponse<Content>.mapData($0) })
    }
    
    public func stop() {
        responseStreamContinuation?.finish(throwing: nil)
        responseStreamContinuation = nil
    }
    
    internal func received(_ data: Data) {
        var newData = data
        if convertToArray, var converted = String(data: newData, encoding: .utf8) {
            converted = converted.replacingOccurrences(of: "\r\n", with: ",")
            converted = "[\(converted)]"
            newData = converted.data(using: .utf8)!
        }
        
        var completeData = newData
        if isJSONObject && !convertToArray {
            if let previousData = cache, newData.first != UInt8(String("{").utf8.first!) {
                completeData = previousData
                completeData.append(newData)
            }
            
            if let newlinePos = completeData.firstIndex(of: UInt8(String("\n").utf8.first!)) {
                if newlinePos != completeData.count-1 {
                    let restData = completeData.subdata(in: newlinePos+1..<completeData.count)
                    cache = restData
                }
                completeData = completeData.subdata(in: 0..<newlinePos)
            } else {
                cache = completeData
                return
            }
        }
        responseStreamContinuation?.yield(completeData)
    }
    
    internal func complete(withError error: Error?) {
        responseStreamContinuation?.finish(throwing: error)
        responseStreamContinuation = nil
    }
    
    fileprivate static func mapData(_ data: Data) throws -> Content {
        if Content.self is Data.Type {
            return data as! Content
        }
        if Content.self is String.Type, let string = String(data: data, encoding: .utf8) {
            return string as! Content
        }
        return try dockerDecoder.decode(Content.self, from: data)
    }
}

public extension APIStreamResponse where Content == String {
    var isJSONObject: Bool { false }
}

public extension APIStreamResponse where Content == Data {
    convenience init(response: HTTPURLResponse, onTermination: (@Sendable (AsyncThrowingStream<Data, Error>.Continuation.Termination) -> Void)? = nil) {
        self.init(response: response, convertToArray: false, onTermination: onTermination)
    }
    
    var isJSONObject: Bool { false }
}
