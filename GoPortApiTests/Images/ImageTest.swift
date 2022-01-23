//
//  ImageTest.swift
//  GoPortApiTests
//
//  Created by Max Vissing on 23.01.22.
//

import XCTest
import GoPortApi

class ImageTest: GoPortApiBaseTest {

    func testImageResponseAPISuccess() async throws {
        let response = try await ImageAPI.imageInspect(host: host, name: "", context: "default", session: session)
        
        XCTAssertEqual(response.id, "sha256:0ed6cc16db71fe88a719ffa7c0dd4f255b3257d729c11b336e8a3063f5637444")
    }

}
