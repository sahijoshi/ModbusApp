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
    
    var modbusViewModel: ModbusViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSpreadsheetView()
        bindToViewModel()
    }
    
    // MARK: - Private Methods
    
    private func setupSpreadsheetView() {
        spreadsheetView.bounces = false
        spreadsheetView.register(ModbusCell.self, forCellWithReuseIdentifier: ModbusCell.identifier)
        spreadsheetView.gridStyle = .solid(width: 1, color: .link)
        spreadsheetView.dataSource = self
        spreadsheetView.delegate = self
    }
    
    // Observe change in modbus data from server
    
    private func bindToViewModel() {
        modbusViewModel = ModbusViewModel()
        modbusViewModel?.getModbusData()
        modbusViewModel?.data.bind(listener: { [weak self] (data) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.reloadSpreadview()
            }
        })
        
        modbusViewModel?.formattedDate.bind(listener: { [weak self] (date) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.lblDate.attributedText = date
            }
        })
        
        modbusViewModel?.error.bind(listener: { (error) in
            // Handle error
            dLog(error?.localizedDescription)
        })
    }
    
    private func reloadSpreadview() {
        spreadsheetView.reloadData()
    }
    
    //    private func searchModbus(text: String) {
    //        let searchString = text.lowercased()
    //        //        let register = "register"
    //        //        let name = "variable_name"
    //        //        let unit = "unit"
    //        //        let value = "regiter_value"
    //        let predicate = NSPredicate(format: "%K CONTAINS[cd] %@ OR %K CONTAINS[cd] %@ OR %K CONTAINS[cd] %@ OR %K CONTAINS[cd] %@", "register", searchString, "variable_name", searchString, "unit", searchString, "regiter_value", searchString )
    //
    //        filteredData = modbus!.data?.filter {
    //            return predicate.evaluate(with: $0)
    //        }
    //
    //        spreadsheetView.reloadData()
    //    }
    
}

// MARK: - SpreadsheetViewDataSource

extension ModbusViewController: SpreadsheetViewDataSource {
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, cellForItemAt indexPath: IndexPath) -> Cell? {
        let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: ModbusCell.identifier, for: indexPath) as! ModbusCell
        guard let modbusViewModel = modbusViewModel else { return cell }
        let headerKey = modbusViewModel.getHeaderKeyFor(section: indexPath.section)
        
        switch indexPath.row {
        case 0:
            // First row which is a header for spreadsheet
            cell.title = modbusViewModel.getHeaderValueFor(key: headerKey)
        default:
            // Rows of spreadsheet
            cell.title = modbusViewModel.getModbusPresentableValueAt(index: indexPath.row - 1, for: headerKey)
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
        guard let modbusViewModel = modbusViewModel else { return 0 }
        return modbusViewModel.numberOfColumns
    }
    
    func numberOfRows(in spreadsheetView: SpreadsheetView) -> Int {
        guard let modbusViewModel = modbusViewModel else { return 0 }
        return modbusViewModel.numberOfRows
    }
    
    func frozenColumns(in spreadsheetView: SpreadsheetView) -> Int {
        guard let modbusViewModel = modbusViewModel else { return 0 }
        return modbusViewModel.frozenColumns
    }
    
    func frozenRows(in spreadsheetView: SpreadsheetView) -> Int {
        guard let modbusViewModel = modbusViewModel else { return 0 }
        return modbusViewModel.frozenRows
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
        //        searchModbus(text: searchText)
    }
}
