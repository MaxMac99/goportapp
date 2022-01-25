//
//  ContainerPruneTest.swift
//  GoPortApiTests
//
//  Created by Max Vissing on 25.01.22.
//

import XCTest
import GoPortApi

class ContainerPruneTest: GoPortApiBaseTest {

    func testContainerPruneAPISuccess() async throws {
        let response = try await ContainerAPI.containerPrune(host: host, session: session)
        
        XCTAssertEqual(response.first!.value.spaceReclaimed, 47103955)
    }

}
