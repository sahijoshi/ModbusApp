//
//  BaseClass.swift
//
//  Created by skj on 5.10.2020
//  Copyright (c) . All rights reserved.
//

import Foundation

struct Modbus: Codable {

  enum CodingKeys: String, CodingKey {
    case date
    case data
  }

  var date: [String]?
  var data: [Data]?



  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    date = try container.decodeIfPresent([String].self, forKey: .date)
    data = try container.decodeIfPresent([Data].self, forKey: .data)
  }

}
