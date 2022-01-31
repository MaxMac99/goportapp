//
//  Project.swift
//  GoPortApi
//
//  Created by Max Vissing on 30.01.22.
//

import Foundation

public struct Project {
    public private(set) var name: String
    private let contextRef: Reference<GoPortContext>
    
    public var context: GoPortContext {
        contextRef.value
    }
    
    init(name: String, context: GoPortContext) {
        self.name = name
        self.contextRef = Reference(context)
    }
}

extension Project: Equatable {
    public static func == (lhs: Project, rhs: Project) -> Bool {
        lhs.name == rhs.name
    }
}

extension Project: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}

extension Project: Identifiable {
    public var id: String { name }
}
