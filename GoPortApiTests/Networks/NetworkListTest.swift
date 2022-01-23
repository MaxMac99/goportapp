//
//  NetworkListTest.swift
//  GoPortApiTests
//
//  Created by Max Vissing on 23.01.22.
//

import XCTest
import GoPortApi

class NetworkListTest: GoPortApiBaseTest {

    func testNetworkListAPISuccess() async throws {
        let response = try await NetworkAPI.networkList(host: host)
        
        XCTAssertEqual(response.first?.value.count, 4)
    }

}
