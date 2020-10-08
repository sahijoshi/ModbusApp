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
    var filteredModbusData: Box<[[String: String]]?> { get }
    var formattedDate: Box<NSMutableAttributedString?> { get }
    var searchText: Box<String?> { get set }
    var noSearchResultMessage: Box<String?> { get }
}

final class ModbusViewModel: ModbusViewModelPresentable {
    var formattedDate: Box<NSMutableAttributedString?> = Box(nil)
    var error: Box<NetworkError?> = Box(nil)
    var filteredModbusData: Box<[[String: String]]?> = Box(nil)
    var searchText: Box<String?> = Box(nil)
    var noSearchResultMessage: Box<String?> = Box(nil)
   
    private let service: WebServices?
    private var headerValues: [String : String]?
    private var headerKeys: [String]?
    private var date: String?
    private var data: [[String: String]]?
    private var columnWidths = [0: 70, 1: 200, 2: 80, 3: 150, 4: 100]

    // return number of columns for spreadsheet
    
    var numberOfColumns: Int {
        guard let headerKeys = headerKeys else { return 0 }
        return headerKeys.count
    }
    
    // return number of columns for spreadsheet
    
    var numberOfRows: Int {
        guard let data = filteredModbusData.value else { return 0 }
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
    
    init(service: WebServices = WebServices()) {
        self.service = service
        bindSearchText()
    }
    
    // MARK: - Private Methods
    
    private func bindSearchText() {
        searchText.bind { [unowned self] (searchText) in
            guard let searchText = searchText, !searchText.isEmpty else {
                self.resetFilteredData()
                return
            }
            self.searchInModbusData(searchText: searchText)
        }
    }
    
    private func resetFilteredData() {
        filteredModbusData.value = data
    }
    
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
        let attributedDate = NSAttributedString(string: " Date: ", attributes: dateAttributes)
        
        let dateAttributesValue: [NSMutableAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 15, weight: .medium),
        ]
        let attributedDateValue = NSAttributedString(string: finalDateString, attributes: dateAttributesValue)
        
        let combination = NSMutableAttributedString()
        combination.append(attributedDate)
        combination.append(attributedDateValue)
        
        return combination
    }
    
    private func searchInModbusData(searchText: String) {
        guard let data = data else { return }

        let searchText = searchText.lowercased()
        let predicate = NSPredicate(format: "%K CONTAINS[cd] %@ OR %K CONTAINS[cd] %@ OR %K CONTAINS[cd] %@ OR %K CONTAINS[cd] %@", "register", searchText, "variable_name", searchText, "unit", searchText, "regiter_value", searchText )
        
        let filteredData = data.filter {
            return predicate.evaluate(with: $0)
        }
        
        filteredModbusData.value = filteredData
        checkForEmptyData(data: filteredModbusData.value)
    }
    
    private func checkForEmptyData(data: [[String: String]]?) {
        noSearchResultMessage.value = data!.isEmpty ? "No Search Results." : ""
    }
}

// MARK: - Public Methods

extension ModbusViewModel {
    // Request for Modbus data from server
    
    func getModbusData(_ completion: @escaping (Bool) -> () = {_ in}) {
        service?.getModbusData { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let modbus):
                self.data = modbus.data
                self.headerKeys = modbus.headerKey
                self.headerValues = modbus.headerValue
                self.filteredModbusData.value = self.data
                self.formattedDate.value = self.formatDate(date: modbus.date)
                self.checkForEmptyData(data: self.filteredModbusData.value)
                completion(true)
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
        guard let data = filteredModbusData.value else { return "" }
        guard let aDatavalue = data[index][key] else { return "" }
        
        return aDatavalue
    }
    
    func getColumnWidthForColumn(column: Int) -> CGFloat {
        guard let width = columnWidths[column] else { return 0 }
        return CGFloat(width)
    }
    
}
