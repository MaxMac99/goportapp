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
    
    internal static func loadHeaders(_ filename: String) throws -> [AnyHashable: Any] {
        guard let url = Bundle(for: self).url(forResource: filename, withExtension: "txt") else {
            throw MockError.fileNotFound
        }
        let data = try Data(contentsOf: url)
        let content = String(bytes: data, encoding: .ascii)
        var decoded = [String: String]()
        for line in content?.split(whereSeparator: \.isNewline) ?? [] {
            let split = line.split(separator: ":")
            if let key = split.first?.trimmingCharacters(in: .whitespaces), let value = split.last?.trimmingCharacters(in: .whitespaces) {
                decoded[key] = value
            }
        }
        return decoded
    }
}
