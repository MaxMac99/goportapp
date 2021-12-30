//
//  Server.swift
//  GoPort
//
//  Created by Max Vissing on 25.12.21.
//

import Foundation

struct Server: Codable {
    var name: String
    var host: URL
}

extension Server: Identifiable {
    var id: String {
        return name
    }
}

enum ServerError: Error {
    case alreadyExists
}

#if DEBUG
extension Server {
    static var preview: [Server] {
        [
            Server(name: "localhost", host: URL(string: "localhost:9212")!),
            Server(name: "Server1", host: URL(string: "192.168.178.10")!),
            Server(name: "Server2", host: URL(string: "192.168.178.30")!),
            Server(name: "Server3", host: URL(string: "192.168.178.40")!),
            Server(name: "Server4", host: URL(string: "192.168.178.50")!)
        ]
    }
}
#endif
