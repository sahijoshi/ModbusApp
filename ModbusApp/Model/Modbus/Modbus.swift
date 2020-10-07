//
//  BaseClass.swift
//
//  Created by skj on 6.10.2020
//  Copyright (c) . All rights reserved.
//

import Foundation

struct Modbus: Codable {
    enum CodingKeys: String, CodingKey {
      case date
      case headerKey = "header_key"
      case data
      case headerValue = "header_value"
    }

    var date: String?
    var headerKey: [String]?
    var data: [[String: String]]?
    var headerValue: [String: String]?

    init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      date = try container.decodeIfPresent(String.self, forKey: .date)
      headerKey = try container.decodeIfPresent([String].self, forKey: .headerKey)
      data = try container.decodeIfPresent([[String: String]].self, forKey: .data)
      headerValue = try container.decodeIfPresent([String: String].self, forKey: .headerValue)
    }
}
