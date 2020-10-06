//
//  Util.swift
//  ModbusApp
//
//  Created by skj on 6.10.2020.
//  Copyright © 2020 skj. All rights reserved.
//

import Foundation

public func dLog<T>(_ object: @autoclosure () -> T, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
    #if DEBUG
        let value = object()
        print(value)
    #endif
}
