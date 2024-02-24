//
//  ServerEndPoints.swift
//  BoxOfficeTracker
//
//  Created by 송하경 on 2/23/24.
//

import Foundation

enum ServerEndPoints: Targetable {
    case getBoxOfficeList(JSONConvertible)
    case getMovieInfo(JSONConvertible)
    
    var baseURL: String {
        switch self {
        case .getBoxOfficeList, .getMovieInfo:
            return ServerConfiguration.movieBaseURL
        }
    }
    
    var path: String {
        switch self {
        case .getBoxOfficeList(_):
            return "/boxoffice/searchWeeklyBoxOfficeList.json"
        case .getMovieInfo(_):
            return "/movie/searchMovieInfo.json"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getBoxOfficeList, .getMovieInfo:
            return .get
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var parameters: RequestParams? {
        switch self {
        case .getBoxOfficeList(let request), .getMovieInfo(let request):
            return .query(request)
        }
    }
}

