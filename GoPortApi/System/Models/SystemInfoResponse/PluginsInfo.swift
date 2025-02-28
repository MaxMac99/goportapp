//
// PluginsInfo.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation

/** Available plugins per type.  &lt;p&gt;&lt;br /&gt;&lt;/p&gt;  &gt; **Note**: Only unmanaged (V1) plugins are included in this list. &gt; V1 plugins are \&quot;lazily\&quot; loaded, and are not returned in this list &gt; if there is no resource using the plugin.  */
public struct PluginsInfo: Codable, Hashable {

    /** Names of available volume-drivers, and network-driver plugins. */
    public var volume: [String]? = nil
    /** Names of available network-drivers, and network-driver plugins. */
    public var network: [String]? = nil
    /** Names of available authorization plugins. */
    public var authorization: [String]? = nil
    /** Names of available logging-drivers, and logging-driver plugins. */
    public var log: [String]? = nil

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case volume = "Volume"
        case network = "Network"
        case authorization = "Authorization"
        case log = "Log"
    }
}

