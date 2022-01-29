// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let projectResources = try? newJSONDecoder().decode(ProjectResources.self, from: jsonData)

import Foundation

// MARK: - ProjectResources
public struct ProjectResources: Codable {
    public var limits: ProjectLimits?
    public var reservations: ProjectReservations?

    enum CodingKeys: String, CodingKey {
        case limits
        case reservations
    }

    public init(limits: ProjectLimits?, reservations: ProjectReservations?) {
        self.limits = limits
        self.reservations = reservations
    }
}
