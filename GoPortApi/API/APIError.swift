//
//  APIError.swift
//  GoPortApi
//
//  Created by Max Vissing on 28.12.21.
//

import Foundation

public enum APIRequestError: Error {
    case invalidURL(String)
}

public enum APIResponseError: Error {
    // 4xx
    case badRequest(String?)
    case unauthorized(String?)
    case forbidden(String?)
    case notFound(String?)
    case notAllowed(String?)
    case conflict(String?)
    case gone(String?)
    // 5xx
    case serverError(String?)
    case notImplemented(String?)
    case badGateway(String?)
    case unavailable(String?)
    
    // Unknown
    case unknown(String?)
    
    public init(statusCode: Int, description: String? = nil) {
        self = APIResponseError.responseError(for: statusCode, description: description)
    }
    
    var statusCode: Int? {
        switch self {
        case .badRequest(_): return 400
        case .unauthorized(_): return 401
        case .forbidden(_): return 403
        case .notFound(_): return 404
        case .notAllowed(_): return 405
        case .conflict(_): return 409
        case .gone(_): return 410
        case .serverError(_): return 500
        case .notImplemented(_): return 501
        case .badGateway(_): return 502
        case .unavailable(_): return 503
        default: return nil
        }
    }
    
    var statusCodeDescription: String? {
        guard let statusCode = statusCode else {
            return nil
        }
        return HTTPURLResponse.localizedString(forStatusCode: statusCode)
    }
    
    private static func responseError(for statusCode: Int, description: String?) -> APIResponseError {
        switch statusCode {
        case 400:
            return APIResponseError.badRequest(description)
        case 401:
            return APIResponseError.unauthorized(description)
        case 403:
            return APIResponseError.forbidden(description)
        case 404:
            return APIResponseError.notFound(description)
        case 405:
            return APIResponseError.notAllowed(description)
        case 409:
            return APIResponseError.conflict(description)
        case 410:
            return APIResponseError.gone(description)
        case 500:
            return APIResponseError.serverError(description)
        case 501:
            return APIResponseError.notImplemented(description)
        case 502:
            return APIResponseError.badRequest(description)
        case 503:
            return APIResponseError.unavailable(description)
        default:
            return APIResponseError.unknown(description)
        }
    }
}
