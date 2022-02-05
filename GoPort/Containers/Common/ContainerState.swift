//
//  ContainerState.swift
//  GoPort
//
//  Created by Max Vissing on 05.02.22.
//

import Foundation

enum ContainerState: String, CaseIterable {
    case created, running, paused, restarting, removing, exited, dead, unknown
}
