//
// HealthStatus.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation

/** Status is one of &#x60;none&#x60;, &#x60;starting&#x60;, &#x60;healthy&#x60; or &#x60;unhealthy&#x60;  - \&quot;none\&quot;      Indicates there is no healthcheck - \&quot;starting\&quot;  Starting indicates that the container is not yet ready - \&quot;healthy\&quot;   Healthy indicates that the container is running correctly - \&quot;unhealthy\&quot; Unhealthy indicates that the container has a problem  */
public enum HealthStatus: String, Codable, CaseIterable {
    case _none = "none"
    case starting = "starting"
    case healthy = "healthy"
    case unhealthy = "unhealthy"
}
