//
//  ImagePruneTest.swift
//  GoPortApiTests
//
//  Created by Max Vissing on 23.01.22.
//

import XCTest
import GoPortApi

class ImagePruneTest: GoPortApiBaseTest {

    func testImagePruneAPISuccess() async throws {
        let response = try await ImageAPI.imagePrune(host: host, context: ["default"], session: session)
        
        XCTAssertEqual(response["default"]?.spaceReclaimed, 1885111433)
    }

}
