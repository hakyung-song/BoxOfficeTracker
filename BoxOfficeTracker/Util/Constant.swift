//
//  Constant.swift
//  BoxOfficeTracker
//
//  Created by 송하경 on 2/24/24.
//

import Foundation

var oneWeekBefore = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date()) ?? Date()
