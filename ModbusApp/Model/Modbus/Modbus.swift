//
//  Data.swift
//
//  Created by skj on 5.10.2020
//  Copyright (c) . All rights reserved.
//

import Foundation

struct Modbus: Codable {

  enum CodingKeys: String, CodingKey {
    case register
    case name
    case value
    case unit
  }

  var register: String?
  var name: String?
  var value: String?
  var unit: String?



  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    register = try container.decodeIfPresent(String.self, forKey: .register)
    name = try container.decodeIfPresent(String.self, forKey: .name)
    value = try container.decodeIfPresent(String.self, forKey: .value)
    unit = try container.decodeIfPresent(String.self, forKey: .unit)
  }

}
