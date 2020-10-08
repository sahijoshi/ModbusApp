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
    @IBOutlet weak var lblNoSearchResult: UILabel!

    var modbusViewModel: ModbusViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupSpreadsheetView()
        bindToViewModel()
    }
    
    // MARK: - Private Methods
    
    private func setupNavigation() {
        title = "Modbus"
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .red
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
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
        modbusViewModel?.filteredModbusData.bind(listener: { [weak self] (data) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.reloadSpreadview()
            }
        })
        
        modbusViewModel?.formattedDate.bind(listener: { [unowned self] (date) in
            DispatchQueue.main.async {
                self.lblDate.attributedText = date
            }
        })
        
        modbusViewModel?.error.bind(listener: { (error) in
            // Handle error
            dLog(error?.localizedDescription)
        })
        
        modbusViewModel?.noSearchResultMessage.bind(listener: { [unowned self] (message) in
            guard let message = message else { return }
            DispatchQueue.main.async {
                self.lblNoSearchResult.isHidden = message.isEmpty
                self.lblNoSearchResult.text = message
            }
        })
    }
    
    private func reloadSpreadview() {
        spreadsheetView.reloadData()
    }
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
            cell.isHeader = true
            cell.title = modbusViewModel.getHeaderValueFor(key: headerKey)
        default:
            // Rows of spreadsheet
            cell.isHeader = false
            cell.title = modbusViewModel.getModbusPresentableValueAt(index: indexPath.row - 1, for: headerKey)
        }
        return cell
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat {
        guard let modbusViewModel = modbusViewModel else { return 0 }
        return modbusViewModel.getColumnWidthForColumn(column: column)
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
        guard let modbusViewModel = modbusViewModel else { return }
        modbusViewModel.searchText.value = searchText
    }
}
