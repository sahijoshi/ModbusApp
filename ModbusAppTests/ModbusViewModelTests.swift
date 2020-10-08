//
//  ModbusViewModelTests.swift
//  ModbusAppTests
//
//  Created by skj on 8.10.2020.
//  Copyright © 2020 skj. All rights reserved.
//

import XCTest
@testable import ModbusApp

class ModbusViewModelTests: XCTestCase {
    var modbusViewModel: ModbusViewModel!
    var mockHTTPURLResponse: HTTPURLResponse?
    
    
    override func setUpWithError() throws {
        mockHTTPURLResponse = HTTPURLResponse.init(url: URL(string: "https://modbus-app.herokuapp.com")!, statusCode: 200, httpVersion: "2.0", headerFields: nil)!
        
        // setup viewmodel and mock session
        
        let service = WebServices()
        modbusViewModel = ModbusViewModel(service: service)
        
        let bundle = Bundle(for: WebServicesTests.self)
        guard let jsonPath = bundle.path(forResource: "modbus", ofType: "json") else { XCTFail(); return }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: jsonPath), options: .mappedIfSafe)
            let mockURLSession = MockURLSession(data: data, urlResponse: mockHTTPURLResponse, error: nil)
            service.session = mockURLSession
            
        } catch {
            XCTFail()
        }
        
    }
    
    override func tearDownWithError() throws {
        mockHTTPURLResponse = nil
        modbusViewModel = nil
    }
    
    //   MARK: Tests
    
    func testCorrectHeaderKeyIsReturned() {
        let expectedKey = "register"
        
        let expectation = self.expectation(description: "correct register header key is returned")
        var receivedKey = ""
        
        modbusViewModel.getModbusData {[weak self] (success) in
            guard let self = self else { return }
            
            receivedKey = self.modbusViewModel.getHeaderKeyFor(section: 0)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertEqual(expectedKey, receivedKey)
        }
        
    }
    
    func testCorrectHeaderValueIsReturned() {
        let expectedValue = "Register"
        
        let expectation = self.expectation(description: "correct register header value is returned")
        var receivedValue = ""
        
        modbusViewModel.getModbusData {[weak self] (success) in
            guard let self = self else { return }
            
            receivedValue = self.modbusViewModel.getHeaderValueFor(key: "register")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertEqual(expectedValue, receivedValue)
        }
    }
    
    func testCorrectNumberOfColumnsIsReturned() {
        let expectedColumns = 5
        
        let expectation = self.expectation(description: "correct column number is returned")
        var receivedColumns = 0
        
        modbusViewModel.getModbusData {[weak self] (success) in
            guard let self = self else { return }
            receivedColumns = self.modbusViewModel.numberOfColumns
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertEqual(expectedColumns, receivedColumns)
        }
        
    }
    
    
    func testCorrectNumberOfRowsIsReturned() {
        let expectedRows = 47
        
        let expectation = self.expectation(description: "empty")
        var receivedRows = 0
        
        modbusViewModel.getModbusData { [weak self] (success) in
            guard let self = self else { return }
            receivedRows = self.modbusViewModel.numberOfRows
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertEqual(expectedRows, receivedRows)
        }
    }
    
    func testCorrectNumberOfResultsIsReturnedOnSearch() {
        let expectedCount = 2
        
        let expectation = self.expectation(description: "correct result is returned on text search")
        var receivedCount = 0
        
        modbusViewModel.getModbusData {[weak self] (success) in
            guard let self = self else { return }
            self.modbusViewModel.searchText.value = "Flow"
            
            self.modbusViewModel.filteredModbusData.bind { (result) in
                receivedCount = result!.count
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertEqual(expectedCount, receivedCount)
        }
    }
    
    func testEmptyfResultsIsReturnedWhenSearchDontMatch() {
        let expectedCount = 0
        
        let expectation = self.expectation(description: "empty result is returned when search text doesnt match")
        var receivedCount = 0
        
        modbusViewModel.getModbusData {[weak self] (success) in
            guard let self = self else { return }
            self.modbusViewModel.searchText.value = "Not Match"
            
            self.modbusViewModel.filteredModbusData.bind { (result) in
                receivedCount = result!.count
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertEqual(expectedCount, receivedCount)
        }
    }
    
    func testCorrectFormattedDateIsReturned() {
        let expectedDate = " Date: Aug 03, 2018 4:06 AM"
        
        let expectation = self.expectation(description: "correct date format is returned")
        var receivedDate = ""
        
        modbusViewModel.getModbusData { [weak self] (success) in
            guard let self = self else { return }
            self.modbusViewModel.formattedDate.bind { (result) in
                receivedDate = result!.string
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertEqual(expectedDate, receivedDate)
        }
    }
}
