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

    override func viewDidLoad() {
        super.viewDidLoad()
        let service = WebServices()
        service.getModbusData { (result) in
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
