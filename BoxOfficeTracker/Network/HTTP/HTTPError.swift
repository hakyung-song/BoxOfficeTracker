//
//  HTTPError.swift
//  BoxOfficeTracker
//
//  Created by 송하경 on 2/23/24.
//

import Foundation

public enum HTTPError: LocalizedError, Equatable, Hashable {
    case invalidRequest
    case badRequest
    case unauthorized
    case forbidden
    case notFound
    case noResponse
    case error4xx(_ code: Int)
    case serverError
    case error5xx(_ code: Int)
    case decodingError
    case urlSessionFailed(_ error: URLError)
    case unknownError
}

