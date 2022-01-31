//
//  Helper.swift
//  GoPortApi
//
//  Created by Max Vissing on 31.01.22.
//

import Foundation

internal class Reference<Value> {
    let value: Value
    
    init(_ value: Value) {
        self.value = value
    }
}
