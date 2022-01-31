//
//  Image.swift
//  GoPortApi
//
//  Created by Max Vissing on 31.01.22.
//

import Foundation

public struct Image: Identifiable {
    public private(set) var id: String
    private let contextRef: Reference<GoPortContext>
    
    public var context: GoPortContext {
        contextRef.value
    }
    
    init(id: String, context: GoPortContext) {
        self.id = id
        self.contextRef = Reference(context)
    }
}

extension Image: Equatable {
    public static func == (lhs: Image, rhs: Image) -> Bool {
        lhs.id == rhs.id
    }
}

extension Image: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
