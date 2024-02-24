//
//  HTTPMethod.swift
//  BoxOfficeTracker
//
//  Created by 송하경 on 2/23/24.
//

import Foundation

public enum HTTPMethod: String, Equatable, Hashable {
  case delete = "DELETE"
  case get = "GET"
  case patch = "PATCH"
  case post = "POST"
  case put = "PUT"
}

