//
//  Utilities.swift
//  GoPort
//
//  Created by Max Vissing on 15.01.22.
//

import Foundation
import SwiftUI

extension Optional {
    var array: [Wrapped]? {
        if let wrapped = self {
            return [wrapped]
        }
        return nil
    }
}
