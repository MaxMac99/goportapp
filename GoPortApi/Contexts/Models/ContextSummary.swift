//
// ContextSummary.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation

public struct ContextSummary: Codable, Hashable {

    /** The names that this context has been given  */
    public var name: String
    /** The description of the context  */
    public var description: String? = nil
    /** The docker endpoint of the context  */
    public var docker: String? = nil
    /** The kubernetes endpoint of the context  */
    public var kubernetes: String? = nil
    /** The orchestrator of the context  */
    public var orchestrator: String? = nil

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case name = "Name"
        case description = "Description"
        case docker = "Docker"
        case kubernetes = "Kubernetes"
        case orchestrator = "Orchestrator"
    }
}

extension ContextSummary: Identifiable {
    public var id: String {
        return name
    }
}

#if DEBUG
public extension ContextSummary {
    static var preview: [ContextSummary] {
        try! MockHelper.load("contextsList")
    }
}
#endif
