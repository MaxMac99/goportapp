//
//  ImageCommitTest.swift
//  GoPortApiTests
//
//  Created by Max Vissing on 23.01.22.
//

import XCTest
import GoPortApi

class ImageCommitTest: GoPortApiBaseTest {

    func testImageCommitAPISuccess() async throws {
        let response = try await ImageAPI.imageCommit(host: host, context: "default", session: session)
        
        XCTAssertEqual(response.id, "sha256:87211bccc6717276dd4fa7a899389c158ece40e05484e27b3ff3ec5d70fb2bae")
    }

}
