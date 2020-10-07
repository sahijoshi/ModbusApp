//
//  ModbudViewModel.swift
//  ModbusApp
//
//  Created by skj on 7.10.2020.
//  Copyright © 2020 skj. All rights reserved.
//

import Foundation
import UIKit.UIFont

protocol ModbusViewModelPresentable {
    var formattedDate: Box<NSMutableAttributedString?> { get }
    var data: Box<[[String: String]]?> { get }
    func getModbusData()
}

final class ModbusViewModel: ModbusViewModelPresentable {
    var formattedDate: Box<NSMutableAttributedString?> = Box(nil)
    var data: Box<[[String: String]]?> = Box(nil)
    var error: Box<NetworkError?> = Box(nil)
    
    private var headerValues: [String : String]?
    private var headerKeys: [String]?
    private var date: String?

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
                self.formattedDate.value = self.formatDate(date: modbus.date)
            case . failure(let error):
                self.error.value = error
            }
        }
    }
    
// MARK: - Private Methods
    
    private func formatDate(date: String?) -> NSMutableAttributedString? {
        guard let date = date else { return nil }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm"
        let sourceDate = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "MMM dd, yyyy h:mm a"

        let finalDateString = dateFormatter.string(from: sourceDate!)
        let dateAttributes: [NSMutableAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 17, weight: .bold),
        ]
        let attributedDate = NSAttributedString(string: "Date: ", attributes: dateAttributes)
        
        let dateAttributesValue: [NSMutableAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14, weight: .medium),
        ]
        let attributedDateValue = NSAttributedString(string: finalDateString, attributes: dateAttributesValue)

        let combination = NSMutableAttributedString()
        combination.append(attributedDate)
        combination.append(attributedDateValue)
        
        return combination
    }
}

// MARK: - Public Methods

extension ModbusViewModel {
    
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
