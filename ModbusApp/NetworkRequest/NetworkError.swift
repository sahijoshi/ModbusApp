//
//  NetworkError.swift
//  ModbusApp
//
//  Created by skj on 6.10.2020.
//  Copyright © 2020 skj. All rights reserved.
//

import Foundation

enum NetworkError: String, Error {
    case invalidRequest = "The request is invalid."
    case noInternetConnection = "Internet connection not available."
    case invalidResponse = "The response is not valid."
    case failed = "Network request failed."
    case notDecodable = "The response could not be decoded."
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        return NSLocalizedString(rawValue, comment: "")
    }
}
