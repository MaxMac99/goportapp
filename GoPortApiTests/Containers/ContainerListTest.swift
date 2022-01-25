//
//  ContainerListTest.swift
//  GoPortApiTests
//
//  Created by Max Vissing on 25.01.22.
//

import XCTest
import GoPortApi

class ContainerListTest: GoPortApiBaseTest {

    func testContainerListAPISuccess() async throws {
        let response = try await ContainerAPI.containerList(host: host, session: session)
        
        XCTAssertEqual(response.first!.value.count, 6)
    }

}
