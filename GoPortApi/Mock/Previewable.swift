//
//  Previewable.swift
//  GoPortApi
//
//  Created by Max Vissing on 16.01.22.
//

import Foundation

public protocol Previewable {
    static var preview: Self { get }
    var asData: Data { get throws }
}

extension Previewable where Self: Encodable {
    public var asData: Data {
        get throws {
            try dockerEncoder.encode(self)
        }
    }
}

public protocol FilePreviewable: Previewable, Codable {
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

public protocol StreamPreviewable {
    static var previews: [Self] { get }
    var asStreamData: Data { get throws }
}

extension StreamPreviewable where Self: Encodable {
    public var asStreamData: Data {
        get throws {
            try dockerEncoder.encode(self)
        }
    }
}

public protocol FileStreamPreviewable: StreamPreviewable, Codable {
    static var previewsFilename: String { get }
}

public extension FileStreamPreviewable {
    static var previews: [Self] {
        try! MockHelper.stream(previewsFilename)
    }
}

public protocol FileStreamPreviewableAsDict: Codable {
    static var previewsFilename: String { get }
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
        try! MockHelper.stream(previewsFilename)
    }
}

extension Dictionary: FileStreamPreviewable where Key == String, Value: FileStreamPreviewableAsDict {
    public static var previewsFilename: String {
        Value.previewsFilename
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
