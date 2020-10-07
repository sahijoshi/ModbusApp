//
//  BaseClass.swift
//
//  Created by skj on 6.10.2020
//  Copyright (c) . All rights reserved.
//

import Foundation

struct Modbus: Codable {

  enum CodingKeys: String, CodingKey {
    case data = "data"
    case headerValue = "header_value"
    case headerKey = "header_key"
    case date
  }

  var data: [[String: String]]?
  var headerValue: [String: String]?
  var headerKey: [String]?
  var date: String?


  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    data = try container.decodeIfPresent([[String: String]].self, forKey: .data)
    headerValue = try container.decodeIfPresent([String: String].self, forKey: .headerValue)
    headerKey = try container.decodeIfPresent([String].self, forKey: .headerKey)
    date = try container.decodeIfPresent(String.self, forKey: .date)
  }

}
