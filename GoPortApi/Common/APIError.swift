//
//  APIError.swift
//  GoPortApi
//
//  Created by Max Vissing on 28.12.21.
//

import Foundation

public enum APIError: Error {
    case invalidURL(String)
    case noHTTPResponse
}
