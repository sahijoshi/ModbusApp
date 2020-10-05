//
//  BaseClass.swift
//
//  Created by skj on 5.10.2020
//  Copyright (c) . All rights reserved.
//

import Foundation

struct ModbusBase: Codable {

  enum CodingKeys: String, CodingKey {
    case date
    case modbus = "data"
  }

  var date: [String]?
  var modbus: [Modbus]?


  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    date = try container.decodeIfPresent([String].self, forKey: .date)
    modbus = try container.decodeIfPresent([Modbus].self, forKey: .modbus)
  }

}
