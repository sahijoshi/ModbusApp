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
    
    var isHeader: Bool = false {
        didSet {
            label.font = .systemFont(ofSize: 15, weight: .medium)
            if isHeader {
                label.font = .systemFont(ofSize: 17, weight: .semibold)
            }
        }
    }
    
    var title:String = "" {
        didSet {
            label.text = title
            label.textAlignment = .center
            label.numberOfLines = 0
            label.textColor = .darkGray
            contentView.addSubview(label)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = contentView.bounds
    }
}
