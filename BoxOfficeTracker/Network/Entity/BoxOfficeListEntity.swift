//
//  BoxOfficeListEntity.swift
//  BoxOfficeTracker
//
//  Created by 송하경 on 2/23/24.
//

import Foundation

struct BoxOfficeListEntity {
    struct Request: Encodable, JSONConvertible {
        var key: String = ServerConstant.key
        var targetDt: String
        let weekGb: String
    }
    
    struct Response: Decodable {
        let boxOfficeResult: BoxOfficeResult
        
        struct BoxOfficeResult: Decodable {
            let weeklyBoxOfficeList: [WeeklyBoxOffice]
            
            struct WeeklyBoxOffice: Decodable {
                let rank: String
                /// 랭킹 신규진입여부
                let rankOldAndNew: RankOldAndNew?
                /// 영화의 대표코드
                let movieCd: String?
                /// 영화명(국문)
                let movieNm: String?
                /// 개봉일
                let openDt: String?
                /// 누적관객수
                let audiAcc: String?
                /// 누적매출액
                let salesAcc: String?
            }
        }
    }
    
    enum WeekGB: String, Encodable {
        case weekly
        case weekend
        case weekday
        
        var apiValue: String {
            switch self {
            case .weekly:
                return "0"
            case .weekend:
                return "1"
            case .weekday:
                return "2"
            }
        }
    }
    
    enum RankOldAndNew: String, Decodable {
        case OLD
        case NEW
    }
}
