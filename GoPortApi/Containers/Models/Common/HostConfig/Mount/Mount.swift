//
// Mount.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation

public struct Mount: Codable, Hashable {

    public enum ModelType: String, Codable, CaseIterable {
        case bind = "bind"
        case volume = "volume"
        case tmpfs = "tmpfs"
        case npipe = "npipe"
    }
    /** Container path. */
    public var target: String? = nil
    /** Mount source (e.g. a volume name, a host path). */
    public var source: String? = nil
    /** The mount type. Available types:  - `bind` Mounts a file or directory from the host into the container. Must exist prior to creating the container. - `volume` Creates a volume with the given name and options (or uses a pre-existing volume with the same name and options). These are **not** removed when the container is removed. - `tmpfs` Create a tmpfs with the given options. The mount source cannot be specified for tmpfs. - `npipe` Mounts a named pipe from the host into the container. Must exist prior to creating the container.  */
    public var type: ModelType? = nil
    /** Whether the mount should be read-only. */
    public var readOnly: Bool? = nil
    /** The consistency requirement for the mount: `default`, `consistent`, `cached`, or `delegated`. */
    public var consistency: String? = nil
    public var bindOptions: MountBindOptions? = nil
    public var volumeOptions: MountVolumeOptions? = nil
    public var tmpfsOptions: MountTmpfsOptions? = nil

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case target = "Target"
        case source = "Source"
        case type = "Type"
        case readOnly = "ReadOnly"
        case consistency = "Consistency"
        case bindOptions = "BindOptions"
        case volumeOptions = "VolumeOptions"
        case tmpfsOptions = "TmpfsOptions"
    }
}

