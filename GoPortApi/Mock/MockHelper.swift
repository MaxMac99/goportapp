//
//  MockHelper.swift
//  GoPortApi
//
//  Created by Max Vissing on 29.12.21.
//

import Foundation

internal enum MockError: Error {
    case fileNotFound
}

internal class MockHelper {
    internal static func load<T: Decodable>(_ filename: String) throws -> T {
        guard let url = Bundle(for: self).url(forResource: filename, withExtension: "json") else {
            throw MockError.fileNotFound
        }
        let data = try Data(contentsOf: url)
        let decoded = try dockerDecoder.decode(T.self, from: data)
        return decoded
    }
}
