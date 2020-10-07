//
//  ModbusViewController.swift
//  Modbus
//
//  Created by skj on 4.10.2020.
//  Copyright © 2020 skj. All rights reserved.
//

import UIKit
import SpreadsheetView

class ModbusViewController: UIViewController {
    @IBOutlet weak var spreadsheetView: SpreadsheetView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var lblDate: UILabel!
    
    var modbus:Modbus?
    var filteredData: [[String: String]]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSpreadsheetView()
        loadData()
    }
    
    // MARK: - Private Methods
    
    func setupSpreadsheetView() {
        spreadsheetView.bounces = false
        spreadsheetView.register(ModbusCell.self, forCellWithReuseIdentifier: ModbusCell.identifier)
        spreadsheetView.gridStyle = .solid(width: 1, color: .link)
        spreadsheetView.dataSource = self
        spreadsheetView.delegate = self
    }
    
    private func loadData() {
        WebServices().getModbusData { [weak self] (result) in
            switch result {
            case .success(let modbus):
                guard let self = self else { return }
                self.modbus = modbus
                self.filteredData = modbus.data
                
                print(self.modbus)

                DispatchQueue.main.async {
                    self.spreadsheetView.reloadData()
                }
            case .failure(let error):
                dLog(error.localizedDescription)
            }
        }
    }
    
    private func searchModbus(text: String) {
        let searchString = text.lowercased()
        //        let register = "register"
        //        let name = "variable_name"
        //        let unit = "unit"
        //        let value = "regiter_value"
        let predicate = NSPredicate(format: "%K CONTAINS[cd] %@ OR %K CONTAINS[cd] %@ OR %K CONTAINS[cd] %@ OR %K CONTAINS[cd] %@", "register", searchString, "variable_name", searchString, "unit", searchString, "regiter_value", searchString )
        
        filteredData = modbus!.data?.filter {
            return predicate.evaluate(with: $0)
        }
        
        spreadsheetView.reloadData()
    }
    
}

// MARK: - SpreadsheetViewDataSource

extension ModbusViewController: SpreadsheetViewDataSource {
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, cellForItemAt indexPath: IndexPath) -> Cell? {
        let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: ModbusCell.identifier, for: indexPath) as! ModbusCell
        let headerKey = modbus!.headerKey![indexPath.section]
        if indexPath.row == 0 {
            cell.data = modbus!.headerValue![headerKey]!
            
        } else {
            cell.data = filteredData![indexPath.row - 1][headerKey]!
        }
        return cell
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat {
        return CGFloat(150)
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow row: Int) -> CGFloat {
        return CGFloat(50)
    }
    
    func numberOfColumns(in spreadsheetView: SpreadsheetView) -> Int {
        guard let key = modbus?.headerKey else {
            return 0
        }
        return key.count
    }
    
    func numberOfRows(in spreadsheetView: SpreadsheetView) -> Int {
        guard let filteredData = filteredData else {
                  return 0
              }
        return filteredData.count + 1
    }
    
        func frozenColumns(in spreadsheetView: SpreadsheetView) -> Int {
            guard let key = modbus?.headerKey else {
                return 0
            }
            return 1
        }
    
    func frozenRows(in spreadsheetView: SpreadsheetView) -> Int {
        guard let filteredData = filteredData else {
                  return 0
              }

        return 1
    }
}

// MARK: - SpreadsheetViewDelegate

extension ModbusViewController: SpreadsheetViewDelegate {
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
}

// MARK: - UISearchBarDelegate

extension ModbusViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchModbus(text: searchText)
    }
}
