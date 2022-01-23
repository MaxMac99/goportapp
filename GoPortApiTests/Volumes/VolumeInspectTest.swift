//
//  VolumeInspectTest.swift
//  GoPortApiTests
//
//  Created by Max Vissing on 23.01.22.
//

import XCTest
import GoPortApi

class VolumeInspectTest: GoPortApiBaseTest {

    func testVolumeInspectAPISuccess() async throws {
        let response = try await VolumeAPI.volumeInspect(host: host, name: "", session: session)
        
        XCTAssertEqual(response.name, "f8da31217ec5551a32b5029843e2ea564d3667c3028dd4901d8c0f15f55d2e63")
    }

}
