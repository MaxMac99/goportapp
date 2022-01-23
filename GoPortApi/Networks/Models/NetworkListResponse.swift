//
//  NetworkListResponse.swift
//  GoPortApi
//
//  Created by Max Vissing on 23.01.22.
//

import Foundation

public typealias NetworkListResponse = [String:[NetworkResponse]]

#if DEBUG
extension NetworkListResponse {
    public static var preview: Self {
        try! MockHelper.load("NetworkListResponse")
    }
}
#endif
