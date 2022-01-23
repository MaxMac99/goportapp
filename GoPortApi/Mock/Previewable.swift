//
//  Previewable.swift
//  GoPortApi
//
//  Created by Max Vissing on 16.01.22.
//

import Foundation

public protocol Previewable: Codable {
    static var preview: Self { get }
}

extension Previewable {
    var asData: Data {
        get throws {
            try dockerEncoder.encode(self)
        }
    }
}

public protocol FilePreviewable: Previewable {
    static var previewFilename: String { get }
}

public extension FilePreviewable {
    static var preview: Self {
        try! MockHelper.load(previewFilename)
    }
}

public protocol FilePreviewableAsDict: Codable {
    static var previewFilename: String { get }
}

public protocol FilePreviewableAsArray: Codable {
    static var previewFilename: String { get }
}

public protocol StreamPreviewable: Codable {
    static var previews: [Self] { get }
}

extension StreamPreviewable {
    var asData: Data {
        get throws {
            try dockerEncoder.encode(self)
        }
    }
}

public protocol FileStreamPreviewable: StreamPreviewable {
    static var previewFilename: String { get }
}

public extension FileStreamPreviewable {
    static var previews: [Self] {
        try! MockHelper.stream(previewFilename)
    }
}

public protocol FileStreamPreviewableAsDict: Codable {
    static var previewFilename: String { get }
}

extension Dictionary: Previewable where Key == String, Value: FilePreviewableAsDict {
    public static var preview: Self {
        try! MockHelper.load(previewFilename)
    }
}

extension Dictionary: FilePreviewable where Key == String, Value: FilePreviewableAsDict {
    public static var previewFilename: String {
        Value.previewFilename
    }
}

extension Dictionary: FilePreviewableAsArray where Key == String, Value: FilePreviewableAsDict {
}

extension Dictionary: StreamPreviewable where Key == String, Value: FileStreamPreviewableAsDict {
    public static var previews: [Self] {
        try! MockHelper.stream(previewFilename)
    }
}

extension Dictionary: FileStreamPreviewable where Key == String, Value: FileStreamPreviewableAsDict {
    public static var previewFilename: String {
        Value.previewFilename
    }
}

extension Array: Previewable where Element: FilePreviewableAsArray {
    public static var preview: Self {
        try! MockHelper.load(previewFilename)
    }
}

extension Array: FilePreviewable where Element: FilePreviewableAsArray {
    public static var previewFilename: String {
        Element.previewFilename
    }
}

extension Array: FilePreviewableAsDict where Element: FilePreviewableAsArray {
}
