//
//  ContainerTopTest.swift
//  GoPortApiTests
//
//  Created by Max Vissing on 25.01.22.
//

import XCTest
import GoPortApi

class ContainerTopTest: GoPortApiBaseTest {

    func testContainerTopAPISuccess() async throws {
        let response = try await ContainerAPI.containerTop(host: host, id: "", session: session)
        
        XCTAssertEqual(response.titles?.count, 8)
    }

}
