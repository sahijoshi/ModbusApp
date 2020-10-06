//
//  MockURLSession.swift
//  ModbusAppTests
//
//  Created by skj on 5.10.2020.
//  Copyright © 2020 skj. All rights reserved.
//

import Foundation
@testable import ModbusApp

class MockURLSession: URLSession {
    var cachedURL: URL?
    
    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        self.cachedURL = request.url
        return URLSessionDataTask()
    }
}
