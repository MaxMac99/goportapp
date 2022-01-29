import Foundation

public enum ProjectCondition: String, Codable {
    case serviceCompletedSuccessfully = "service_completed_successfully"
    case serviceHealthy = "service_healthy"
    case serviceStarted = "service_started"
}
