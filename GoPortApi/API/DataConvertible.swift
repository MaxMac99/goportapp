//
//  DataConvertible.swift
//  GoPortApi
//
//  Created by Max Vissing on 25.01.22.
//

import Foundation

public protocol DataConvertible {
    static func convert(_ data: Data) throws -> Self
}

public protocol DataArrayConvertible {
    static func convert(_ data: Data) -> [Self]
}

extension Array: DataConvertible where Element: DataArrayConvertible {
    public static func convert(_ data: Data) throws -> Array<Element> {
        Element.convert(data)
    }
}

public enum DataConvertibleError: Error {
    case notImplemented
    case invalidResponse
}
