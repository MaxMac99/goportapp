//
//  ContainerWaitTest.swift
//  GoPortApiTests
//
//  Created by Max Vissing on 25.01.22.
//

import XCTest
import GoPortApi

class ContainerWaitTest: GoPortApiBaseTest {

    func testContainerWaitAPISuccess() async throws {
        let response = try await ContainerAPI.containerWait(host: host, id: "", session: session)
        
        XCTAssertEqual(response.statusCode, 137)
    }

}
