//
//  Constant.swift
//  BoxOfficeTracker
//
//  Created by 송하경 on 2/23/24.
//

import Foundation

func getDateFormat(date: Date = Date()) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyyMMdd"
    
    return dateFormatter.string(from: date)
}

func convertDate(inputDate: String, stringType: String) -> String? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = stringType
    
    if let date = dateFormatter.date(from: inputDate) {
        dateFormatter.dateFormat = "yyyy.MM.dd"
        return dateFormatter.string(from: date)
    }else {
        return nil
    }
}

func addCommasToNumberString(_ numberString: String) -> String? {
    if let number = Int(numberString) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        if let formattedNumberString = formatter.string(from: NSNumber(value: number)) {
            return formattedNumberString
        }
    } else {
        return nil
    }
    return nil
}
