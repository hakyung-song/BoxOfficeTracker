//
//  Targetable.swift
//  BoxOfficeTracker
//
//  Created by 송하경 on 2/23/24.
//

import Foundation

enum RequestParams {
    case query(_ parameter: JSONConvertible?)
    case body(_ parameter: JSONConvertible?)
}

protocol Targetable {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var parameters: RequestParams? { get }
    func asURLRequest() -> URLRequest
}

extension Targetable {
    public func asURLRequest() -> URLRequest {
        let url = URL(string: baseURL)!
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = headers
        
        switch parameters {
        case .query(let parameter):
            let dict = try? parameter?.toJSONDictionary()
            let queryParams = dict?.compactMap { URLQueryItem(name: $0.key, value: "\($0.value)") }
            var components = URLComponents(string: url.appendingPathComponent(path).absoluteString)
            components?.queryItems = queryParams
            urlRequest.url = components?.url
        case .body(let parameter):
            urlRequest.httpBody = try? parameter?.toJSONData()
        case .none:
            return urlRequest
        }
        
        return urlRequest
    }
}

