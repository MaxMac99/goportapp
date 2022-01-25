//
//  ContainerCreateTest.swift
//  GoPortApiTests
//
//  Created by Max Vissing on 25.01.22.
//

import XCTest
import GoPortApi

class ContainerCreateTest: GoPortApiBaseTest {

    func testContainerCreateAPISuccess() async throws {
        let response = try await ContainerAPI.containerCreate(host: host, body: ContainerCreateConfig.preview, session: session)
        
        XCTAssertEqual(response.id, "892ff6515212f4ace86203ef69c67f9dd98d3abee00493b957cd358b8aa6fce0")
    }

}
