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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    private func loadData() {
        WebServices().getModbusData { (result) in
            switch result {
            case .success(let modbus):
                print("success")
            case .failure(let error):
                print("failure")
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
