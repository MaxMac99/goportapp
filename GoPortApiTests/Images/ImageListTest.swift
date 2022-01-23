//
//  ImageListTest.swift
//  GoPortApiTests
//
//  Created by Max Vissing on 23.01.22.
//

import XCTest
import GoPortApi

class ImageListTest: GoPortApiBaseTest {

    func testImageListAPISuccess() async throws {
        let response = try await ImageAPI.imageList(host: host, context: ["default"], session: session)
        
        XCTAssertEqual(response.count, 1)
    }

}
