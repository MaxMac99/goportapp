//
//  Server.swift
//  GoPortApi
//
//  Created by Max Vissing on 29.01.22.
//

import Foundation

public enum ServerError: Error {
    case contextNotFound
}

public struct Server {
    
    public let name: String
    public let host: URL
    public private(set) var contexts: [GoPortContext] = []
    public private(set) var allContextsSelected: Bool = true
    public private(set) var selectedContexts: [GoPortContext] = []
    public var session: NetworkingSession = .shared
    
    internal var selectedContextsString: [String] {
        if allContextsSelected {
            return ["all"]
        }
        return selectedContexts.map { $0.name }
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let name = try values.decode(String.self, forKey: .name)
        let host = try values.decode(URL.self, forKey: .host)
        let contexts = try values.decode([String].self, forKey: .contexts)
        let allContextsSelected = try values.decode(Bool.self, forKey: .allContextsSelected)
        let selectedContexts = try values.decode([String].self, forKey: .selectedContexts)
        self.init(name: name, host: host, contexts: contexts, allContextsSelected: allContextsSelected, selectedContexts: selectedContexts)
    }
    
    public init(name: String, host: URL, contexts: [String] = [], allContextsSelected: Bool = true, selectedContexts: [String] = [], session: NetworkingSession = .shared) {
        self.name = name
        self.host = host
        self.allContextsSelected = allContextsSelected
        self.session = session
        self.contexts = contexts.map({ GoPortContext(name: $0, server: self) })
        if allContextsSelected {
            self.selectedContexts = self.contexts
        } else {
            self.selectedContexts = selectedContexts.map({ value -> GoPortContext? in
                guard let context = self.contexts.first(where: { $0.name == value }) else {
                    return nil
                }
                return context
            })
            .compactMap({ $0 })
            .sorted(by: selectedContextComparator)
        }
    }
    
    mutating internal func updateContexts(_ contexts: [String]) {
        let newContexts: [GoPortContext] = contexts
            .filter({ context in
                !self.contexts.contains(where: { $0.name == context })
            })
            .map({ GoPortContext(name: $0, server: self) })
            .compactMap({ $0 })
            .sorted(by: contextComparator)
        self.contexts.append(contentsOf: newContexts)
        if allContextsSelected {
            self.selectedContexts = self.contexts
        } else {
            selectedContexts = selectedContexts.map({ value -> GoPortContext? in
                guard let context = self.contexts.first(where: { $0 == value }) else {
                    return nil
                }
                return context
            })
            .compactMap({ $0 })
            selectedContexts.append(contentsOf: newContexts)
            selectedContexts = selectedContexts.sorted(by: selectedContextComparator)
        }
    }
    
    public mutating func toggle(context: GoPortContext) {
        guard contexts.contains(context), contexts.count > 1 else {
            return
        }
        
        if allContextsSelected {
            allContextsSelected = false
            selectedContexts = contexts
        }
        
        if let index = selectedContexts.firstIndex(of: context) {
            selectedContexts.remove(at: index)
        } else {
            selectedContexts.append(context)
        }
        selectedContexts = selectedContexts.sorted(by: selectedContextComparator)
        
        if selectedContexts == contexts {
            allContextsSelected = true
        }
    }
    
    public mutating func moveContext(fromOffset: IndexSet, toOffset: Int) {
        contexts.move(fromOffsets: fromOffset, toOffset: toOffset)
        selectedContexts = selectedContexts.sorted(by: selectedContextComparator)
    }
    
    private func contextComparator(left: GoPortContext, right: GoPortContext) -> Bool {
        if left.name == "default" {
            return true
        }
        if right.name == "default" {
            return false
        }
        return left.name < right.name
    }
    
    private func selectedContextComparator(left: GoPortContext, right: GoPortContext) -> Bool {
        guard let indexL = contexts.firstIndex(of: left), let indexR = contexts.firstIndex(of: right) else {
            return contextComparator(left: left, right: right)
        }
        return indexL < indexR
    }
    
    internal func stringToDockerContext<Values>(_ items: [String:Values]) throws -> [(context: GoPortContext, response: Values)] {
        try items.map({ (key: String, value: Values) in
            guard let context = contexts.first(where: { $0.name == key }) else {
                throw ServerError.contextNotFound
            }
            return (context, value)
        }).sorted(by: {
            selectedContextComparator(left: $0.0, right: $1.0)
        })
    }
}

extension Server: Identifiable {
    public var id: String { name }
}

extension Server: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(host)
    }
}

extension Server: Equatable {
    public static func == (lhs: Server, rhs: Server) -> Bool {
        lhs.name == rhs.name && lhs.host == rhs.host
    }
}

extension Server: Codable {
    private enum CodingKeys: String, CodingKey {
        case name, host, contexts, allContextsSelected, selectedContexts
    }
    
    public func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try values.encode(name, forKey: .name)
        try values.encode(host, forKey: .host)
        try values.encode(allContextsSelected, forKey: .allContextsSelected)
        try values.encode(contexts.map({ $0.name }), forKey: .contexts)
        try values.encode(selectedContexts.map({ $0.name }), forKey: .selectedContexts)
    }
}

#if DEBUG
extension Server {
    public static var preview: [Server] {
        var localhost = Server(name: "localhost", host: URL(string: "localhost:9212/v1")!, session: .preview)
        localhost.contexts = [
            GoPortContext(name: "default", server: localhost),
            GoPortContext(name: "remote", server: localhost)
        ]
        var remote = Server(name: "remote", host: URL(string: "example.com/v1")!, session: .preview)
        remote.contexts = [
            GoPortContext(name: "default", server: remote),
            GoPortContext(name: "somewhere", server: remote)
        ]
        
        return [localhost, remote]
    }
}
#endif
