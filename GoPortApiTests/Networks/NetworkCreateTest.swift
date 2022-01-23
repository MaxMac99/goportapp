//
//  NetworkCreateTest.swift
//  GoPortApiTests
//
//  Created by Max Vissing on 23.01.22.
//

import XCTest
@testable import GoPortApi

class NetworkCreateTest: GoPortApiBaseTest {

    func testNetworkCreateAPISuccess() async throws {
        let response = try await NetworkAPI.networkCreate(host: host, networkConfig: NetworkConfig(name: "test"), session: session)
        
        XCTAssertEqual(response.id, "0e5797131d9830d3aba861ca8db7a985424d6551044f25efad54eba1463f845f")
    }

}
