//
//  APIRequest.swift
//  GoPortApi
//
//  Created by Max Vissing on 15.01.22.
//

import Foundation

internal struct APIRequest<Body: Encodable> {
    var method: HTTPMethod = .GET
    var host: URL
    var path: APIPathProtocol
    var queryParameters: [String:Any?] = [:]
    var headerArgs: [String:String] = [:]
    var body: Body? = nil
    
    init(method: HTTPMethod = .GET, host: URL, path: APIPathProtocol, query: [String:Any?] = [:], header: [String:String] = [:], body: Body? = nil) {
        self.method = method
        self.host = host
        self.path = path
        self.queryParameters = query
        self.headerArgs = header
        self.body = body
    }
    
    var queryArgs: [URLQueryItem] {
        APIRequest.mapValuesToQueryItems(queryParameters)
    }
    
    var bodyData: Data? {
        get throws {
            if let body = body as? Data {
                return body
            }
            if let body = body {
                return try dockerEncoder.encode(body)
            }
            return nil
        }
    }
    
    func createURLRequest() throws -> URLRequest {
        var fullHost = host
        if host.scheme != "http" && host.scheme != "https" {
            let fullURLString = "http://\(host.absoluteString)"
            guard let tempFullHost = URL(string: fullURLString) else {
                throw APIRequestError.invalidURL(fullURLString)
            }
            fullHost = tempFullHost
        }
        let hostWithComp = fullHost.appendingPathComponent(path.path)
        guard var urlComponents = URLComponents(url: hostWithComp, resolvingAgainstBaseURL: true) else {
            throw APIRequestError.invalidURL(hostWithComp.absoluteString)
        }
        urlComponents.queryItems = queryArgs
        if hostWithComp.port == nil {
            urlComponents.port = GoPortAPI.defaultPort
        }
        guard let url = urlComponents.url else {
            throw APIRequestError.invalidURL(hostWithComp.absoluteString)
        }
        var request = URLRequest(url: url)
        for (header, field) in headerArgs {
            request.addValue(header, forHTTPHeaderField: field)
        }
        request.httpMethod = method.rawValue
        request.httpBody = try bodyData
        return request
    }
    
    private static func mapValuesToQueryItems(_ source: [String: Any?]) -> [URLQueryItem] {
        let destination = source.filter { $0.value != nil }.reduce(into: [URLQueryItem]()) { result, item in
            if let collection = item.value as? [Any?] {
                collection.filter { $0 != nil }.map { "\($0!)" }.forEach { value in
                    result.append(URLQueryItem(name: item.key, value: value))
                }
            } else if let value = item.value {
                result.append(URLQueryItem(name: item.key, value: "\(value)"))
            }
        }
        
        if destination.isEmpty {
            return []
        }
        return destination
    }
}

extension APIRequest where Body == Data {
    init(method: HTTPMethod = .GET, host: URL, path: APIPathProtocol, query: [String:Any?] = [:], header: [String:String] = [:], body: Body? = nil) {
        self.method = method
        self.host = host
        self.path = path
        self.queryParameters = query
        self.headerArgs = header
        self.body = body
    }
}
