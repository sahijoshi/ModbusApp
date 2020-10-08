//
//  WebServicesTests.swift
//  ModbusAppTests
//
//  Created by skj on 5.10.2020.
//  Copyright © 2020 skj. All rights reserved.
//

import XCTest
@testable import ModbusApp

class WebServicesTests: XCTestCase {
    var mockHTTPURLResponse: HTTPURLResponse?

    override func setUpWithError() throws {
        mockHTTPURLResponse = HTTPURLResponse.init(url: URL(string: "https://modbus-prod.herokuapp.com")!, statusCode: 200, httpVersion: "2.0", headerFields: nil)!
    }
    
    override func tearDownWithError() throws {
        mockHTTPURLResponse = nil
    }
    
    // MARK: Test
    
    // test url host and url path is valid for getModbusData
    
    func testGetModbusDataURLAndPath() {
        let mockURLSession = MockURLSession(data: nil, urlResponse: nil, error: nil)
        let service = WebServices()
        service.session = mockURLSession
        
        service.getModbusData { (result) in
            // process result
        }
        
        XCTAssertEqual(mockURLSession.cachedURL?.host, "modbus-prod.herokuapp.com", "Invalid Host")
        XCTAssertEqual(mockURLSession.cachedURL?.path, "/modbus", "Invalid path")
    }
    
    // test valid data is received on getModbusData request
    
    func testGetModbusDataOnSuccessReturnModbus() {
        let service = WebServices()
        var modbus: [[String: String]]?
        
        let bundle = Bundle(for: WebServicesTests.self)
        guard let jsonPath = bundle.path(forResource: "modbus", ofType: "json") else { XCTFail(); return }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: jsonPath), options: .mappedIfSafe)
            
            let mockURLSession = MockURLSession(data: data, urlResponse: mockHTTPURLResponse, error: nil)
            service.session = mockURLSession
            
            let modbusExpectation = expectation(description: "modbus")
            
            service.getModbusData {(result) in
                switch result {
                case .success(let modbusBase):
                    modbus = modbusBase.data
                    modbusExpectation.fulfill()
                case .failure:
                    print("handle error")
                }
            }
            
            waitForExpectations(timeout: 1) { (error) in
                XCTAssertNotNil(modbus)
            }
            
        } catch {
            XCTFail()
        }
    }
    
    // test data error is handled properly

    func testGetModbusResponseWithErrorInData() {
        let expectedError = NetworkError.notDecodable

        let service = WebServices()
        var errorResponse:NetworkError?

        let bundle = Bundle(for: WebServicesTests.self)
        guard let jsonPath = bundle.path(forResource: "invalid", ofType: "json") else { XCTFail(); return }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: jsonPath), options: .mappedIfSafe)
            let mockURLSession = MockURLSession(data: data, urlResponse: mockHTTPURLResponse, error: nil)
            service.session = mockURLSession
            
            let modbusExpectation = expectation(description: "empty")
            
            service.getModbusData {(result) in
                switch result {
                case .success:
                    print("handle error")
                case .failure(let error):
                    errorResponse = error
                    modbusExpectation.fulfill()
                }
            }
            
            waitForExpectations(timeout: 1) { (error) in
                XCTAssertEqual(expectedError, errorResponse)
            }
            
        } catch {
            XCTFail()
        }
    }
    
    // test empty response is handled properly

    func testGetModbusResponseWithEmptyResponse() {
        let expectedError = NetworkError.invalidResponse
        let service = WebServices()
        let mockURLSession = MockURLSession(data: nil, urlResponse: nil, error: nil)
        service.session = mockURLSession
        var errorResponse:NetworkError?
        
        let modbusExpectation = expectation(description: "error")
        
        service.getModbusData { (result) in
            switch result {
            case .success:
                print("handle success")
            case .failure(let error):
                errorResponse = error
                modbusExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertEqual(expectedError, errorResponse)
        }
    }
}
