//
//  ContainerInspectTest.swift
//  GoPortApiTests
//
//  Created by Max Vissing on 25.01.22.
//

import XCTest
import GoPortApi

class ContainerInspectTest: GoPortApiBaseTest {

    func testContainerInspectAPISuccess() async throws {
        let response = try await ContainerAPI.containerInspect(host: host, id: "", session: session)
        
        XCTAssertEqual(response.id, "d36502ca6370d70dc2ba59f3712656df252e7b17d5e2d064837f1b722edd12d7")
    }
    
}
