//
//  ContainerChangeTest.swift
//  GoPortApiTests
//
//  Created by Max Vissing on 25.01.22.
//

import XCTest
import GoPortApi

class ContainerChangeTest: GoPortApiBaseTest {

    func testContainerChangeAPISuccess() async throws {
        let response = try await ContainerAPI.containerChanges(host: host, id: "", session: session)
        
        XCTAssertEqual(response.count, 3)
    }

}
