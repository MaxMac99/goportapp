//
//  GoPortApiBaseTest.swift
//  GoPortApiTests
//
//  Created by Max Vissing on 27.12.21.
//

import XCTest
@testable import GoPortApi

class GoPortApiBaseTest: XCTestCase {
    
    let session = MockNetworkingSession()
    let host = URL(string: "localhost")!

}
