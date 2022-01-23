//
//  NetworkPruneTest.swift
//  GoPortApiTests
//
//  Created by Max Vissing on 23.01.22.
//

import XCTest
import GoPortApi

class NetworkPruneTest: GoPortApiBaseTest {

    func testNetworkPruneAPISuccess() async throws {
        let response = try await NetworkAPI.networkPrune(host: host)
        
        XCTAssertEqual(response.first?.value.networksDeleted?.count, 1)
    }

}
