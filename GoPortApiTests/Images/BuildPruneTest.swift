//
//  BuildPruneTest.swift
//  GoPortApiTests
//
//  Created by Max Vissing on 23.01.22.
//

import XCTest
import GoPortApi

class BuildPruneTest: GoPortApiBaseTest {

    func testBuildPruneAPISuccess() async throws {
        let response = try await ImageAPI.buildPrune(host: host, session: session)
        
        XCTAssertEqual(response.first?.value.cachesDeleted?.count, 16)
    }

}
