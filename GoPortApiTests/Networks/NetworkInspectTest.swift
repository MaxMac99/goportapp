//
//  NetworkInspectTest.swift
//  GoPortApiTests
//
//  Created by Max Vissing on 23.01.22.
//

import XCTest
import GoPortApi

class NetworkInspectTest: GoPortApiBaseTest {

    func testNetwowrkInspectAPISuccess() async throws {
        let response = try await NetworkAPI.networkInspect(host: host, id: "", session: session)
        
        XCTAssertEqual(response.id, "225bc73cff772e7b5db158aede92a2bfb092a6bddd9e13b33b6642826ba7369c")
    }

}
