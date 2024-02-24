//
//  Network.swift
//  BoxOfficeTracker
//
//  Created by 송하경 on 2/23/24.
//

import Combine
import Foundation

struct Network {
    func request<T: Decodable>(_ endpoint: Targetable, responseType: T.Type) async -> Result<T, HTTPError> {
        NetworkLogger.requestLog(request: endpoint.asURLRequest())
        do {
            let (data, response) = try await URLSession.shared.data(for: endpoint.asURLRequest())
            guard let response = response as? HTTPURLResponse else {
                return .failure(.noResponse)
            }
            NetworkLogger.responseLog(data: data, response: response, error: nil)
            switch response.statusCode {
            case 200...299:
                guard let decodedResponse = try? JSONDecoder().decode(responseType, from: data) else {
                    return .failure(.decodingError)
                }
                return .success(decodedResponse)
            case 401:
                return .failure(.unauthorized)
            default:
                return .failure(httpError(response.statusCode))
            }
        } catch {
            return .failure(.unknownError)
        }
    }
}

extension Network {
    private func httpError(_ statusCode: Int) -> HTTPError {
        switch statusCode {
        case 400:
            return .badRequest
        case 401:
            return .unauthorized
        case 403:
            return .forbidden
        case 404:
            return .notFound
        case 402, 405...499:
            return .error4xx(statusCode)
        case 500:
            return .serverError
        case 501...599:
            return .error5xx(statusCode)
        default:
            return .unknownError
        }
    }
}
