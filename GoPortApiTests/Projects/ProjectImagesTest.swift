//
//  ProjectImagesTest.swift
//  GoPortApiTests
//
//  Created by Max Vissing on 29.01.22.
//

import XCTest
import GoPortApi

class ProjectImagesTest: GoPortApiBaseTest {

    func testProjectImagesAPISuccess() async throws {
        let response = try await ProjectAPI.projectImages(host: host, name: "", session: session)
        
        XCTAssertEqual(response.first?.id, "sha256:dcbd72bdd6a28708b829bdf06e127ea9bf74e45888f23daf6acffc008367f775")
    }

}
