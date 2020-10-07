//
//  ModbudViewModel.swift
//  ModbusApp
//
//  Created by skj on 7.10.2020.
//  Copyright © 2020 skj. All rights reserved.
//

import Foundation

protocol ModbusViewModelPresentable {
    var date: String? { get }
    var data: Box<[[String: String]]?> { get }
    func getModbusData()
}

final class ModbusViewModel: ModbusViewModelPresentable {
    var date: String?
    private var headerKeys: [String]?
    var data: Box<[[String: String]]?> = Box(nil)
    private var headerValues: [String : String]?
    var error: Box<NetworkError?> = Box(nil)
    
    // return number of columns for spreadsheet
    
    var numberOfColumns: Int {
        guard let headerKeys = headerKeys else { return 0 }
        return headerKeys.count
    }
    
    var numberOfRows: Int {
        guard let data = data.value else { return 0 }
        return data.count + 1
    }
    
    var frozenColumns: Int {
        guard numberOfColumns > 0 else { return 0 }
        return 1
    }
    
    var frozenRows: Int {
        guard numberOfRows > 0 else { return 0 }
        return 1
    }
    
    // Request for Modbus data from server
    
    func getModbusData() {
        WebServices().getModbusData { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let modbus):
                self.data.value = modbus.data
                self.headerKeys = modbus.headerKey
                self.headerValues = modbus.headerValue
            case . failure(let error):
                self.error.value = error
            }
        }
    }
    
    func getHeaderKeyFor(section: Int) -> String {
        guard let headerKey = headerKeys?[section] else { return "" }
        return headerKey
    }
    
    func getHeaderValueFor(key: String) -> String {
        guard let headerValue = headerValues?[key] else { return "" }
        return headerValue
    }
    
    func getModbusPresentableValueAt(index: Int, for key:String) -> String {
        guard let data = data.value else { return "" }
        guard let aDatavalue = data[index][key] else { return "" }
        
        return aDatavalue
    }
    
}
