//
//  MockHelper.swift
//  GoPortApi
//
//  Created by Max Vissing on 29.12.21.
//

import Foundation

internal enum MockError: Error {
    case fileNotFound
    case invalidEncoding
}

internal class MockHelper {
    internal static func loadFile(_ filename: String, withExtension: String = "json") throws -> Data {
        guard let url = Bundle(for: self).url(forResource: filename, withExtension: withExtension) else {
            throw MockError.fileNotFound
        }
        return try Data(contentsOf: url)
    }
    
    internal static func load<T: Decodable>(_ filename: String) throws -> T {
        let decoded = try dockerDecoder.decode(T.self, from: try loadFile(filename))
        return decoded
    }
    
    internal static func loadHeaders(_ filename: String) throws -> [AnyHashable: Any] {
        let content = String(bytes: try loadFile(filename, withExtension: "txt"), encoding: .ascii)
        var decoded = [String: String]()
        for line in content?.split(whereSeparator: \.isNewline) ?? [] {
            let split = line.split(separator: ":")
            if let key = split.first?.trimmingCharacters(in: .whitespaces), let value = split.last?.trimmingCharacters(in: .whitespaces) {
                decoded[key] = value
            }
        }
        return decoded
    }
    
    internal static func stream<T: Decodable>(_ filename: String) throws -> [T] {
        guard var string = String(data: try loadFile(filename), encoding: .utf8) else {
            throw MockError.invalidEncoding
        }
        string = string.replacingOccurrences(of: "\r", with: "")
        let answers = string.componentsSeparatedBy(separators: ["\n\n"])
        var decoded = [T]()
        for answer in answers {
            decoded.append(try dockerDecoder.decode(T.self, from: answer.data(using: .utf8)!))
        }
        return decoded
    }
}

fileprivate extension String {
    func componentsSeparatedBy(separators: [String]) -> [String] {
        return separators.reduce([self]) { result, separator in
            return result.flatMap { $0.components(separatedBy: separator) }
        }
        .map { $0.trimmingCharacters(in: .whitespaces) }
    }
}
