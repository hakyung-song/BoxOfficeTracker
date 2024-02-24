//
//  MovieService.swift
//  BoxOfficeTracker
//
//  Created by 송하경 on 2/23/24.
//

import Combine
import Foundation

protocol MovieAPI {
    func getBoxOfficeList(request: JSONConvertible) async -> Result<BoxOfficeListEntity.Response, HTTPError>
    func getMovieInfo(request: JSONConvertible) async -> Result<MovieEntity.Response, HTTPError>
}

class MovieService: MovieAPI {
    private var networkRequest = Network()
    
    func getBoxOfficeList(request: JSONConvertible) async -> Result<BoxOfficeListEntity.Response, HTTPError> {
        return await networkRequest.request(ServerEndPoints.getBoxOfficeList(request), responseType: BoxOfficeListEntity.Response.self)
    }
    
    func getMovieInfo(request: JSONConvertible) async -> Result<MovieEntity.Response, HTTPError> {
        return await networkRequest.request(ServerEndPoints.getMovieInfo(request), responseType: MovieEntity.Response.self)
    }
}

