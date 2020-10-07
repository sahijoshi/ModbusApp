//
//  ModbusCell.swift
//  ModbusApp
//
//  Created by skj on 7.10.2020.
//  Copyright © 2020 skj. All rights reserved.
//

import SpreadsheetView

class ModbusCell: Cell {
    static let identifier = "ModbusCell"
    
    private let label = UILabel()
    
    var data:String = "" {
        didSet {
            label.text = data
            label.textAlignment = .center
            contentView.addSubview(label)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = contentView.bounds
    }
}
