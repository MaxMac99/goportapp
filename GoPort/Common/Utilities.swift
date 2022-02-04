//
//  Utilities.swift
//  GoPort
//
//  Created by Max Vissing on 15.01.22.
//

import Foundation
import SwiftUI

extension Optional {
    var array: [Wrapped]? {
        if let wrapped = self {
            return [wrapped]
        }
        return nil
    }
}

let byteCountFormatter: ByteCountFormatter = {
    let formatter = ByteCountFormatter()
    formatter.allowedUnits = .useAll
    formatter.countStyle = .file
    formatter.includesUnit = true
    formatter.isAdaptive = true
    return formatter
}()
let relativeDateFormatter: RelativeDateTimeFormatter = {
    let formatter = RelativeDateTimeFormatter()
    formatter.unitsStyle = .full
    return formatter
}()
let numberFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    return formatter
}()

struct Utilities {
    static func shortTag(tag: String) -> String {
        var beginOffset = tag.startIndex
        if let offset = tag.firstIndex(of: "/") {
            beginOffset = tag.index(offset, offsetBy: 1)
        }
        var endOffset = tag.endIndex
        if let offset = tag.lastIndex(of: ":") {
            endOffset = offset
        }
        return String(tag[beginOffset..<endOffset])
    }
    
    static func shortId(id: String) -> String {
        guard id.starts(with: "sha") else {
            return id
        }
        let length = 8
        var startOffset = id.startIndex
        if let offset = id.firstIndex(of: ":") {
            startOffset = id.index(offset, offsetBy: 1)
        }
        let end = id.index(startOffset, offsetBy: length)
        return String(id[startOffset..<end])
    }
}

enum ContextLoadingError: Error {
    case invalidResponse
    case noContext
}
