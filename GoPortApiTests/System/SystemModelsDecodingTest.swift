//
//  SystemModelsDecodingTest.swift
//  GoPortApiTests
//
//  Created by Max Vissing on 30.12.21.
//

import XCTest
@testable import GoPortApi

class SystemModelsDecodingTest: XCTestCase {
    
    func testSystemDataUsageResponseDecoding() throws {
        let response: SystemDataUsageResponse = try MockHelper.load(SystemDataUsageResponse.previewFilename)
        
        XCTAssertEqual(response["default"]!.layersSize, 11110455288)
    }
    
    func testSystemInfoResponseDecoding() throws {
        let response: SystemInfoResponse = try MockHelper.load(SystemInfoResponse.previewFilename)
        
        XCTAssertEqual(response["default"]!.id, "HARP:XNQX:UFW5:QMYN:S2CA:T6JS:DEM7:DSPB:KQON:PZLG:Y2YU:AJFY")
    }
    
    func testSystemVersionResponseDecoding() throws {
        let response: SystemVersionResponse = try MockHelper.load(SystemVersionResponse.previewFilename)
        
        XCTAssertEqual(response.version, "20.10.11")
    }
    
    func testSystemEventsResponseDecoding() throws {
        let response: SystemEventsResponse = try MockHelper.load(SystemEventsResponse.previewFilename)
        
        XCTAssertEqual(response["default"]!.actor!.id, "4cb1fa3862ac93bb9d82922622e2215f16faba7b4df9c5fe52717fbf28690996")
    }
    
    func testSystemPingResponseDecoding() throws {
        let response: SystemPingResponse = try MockHelper.load(SystemPingResponse.previewFilename)
        
        XCTAssertEqual(response.count, 5)
    }
    
    func testSystemPingResponseHeaderDecoding() throws {
        let response: SystemPingHeader = try SystemPingHeader(MockHelper.loadHeaders(SystemPingHeader.previewFilename))
        
        XCTAssertEqual(response.goportVersion, "v1")
    }

}
