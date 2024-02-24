//
//  MovieDetailViewModel.swift
//  BoxOfficeTracker
//
//  Created by 송하경 on 2/23/24.
//

import Combine
import Foundation

class MovieDetailViewModel {
    var movieDetailSubject: PassthroughSubject<MovieEntity.Response.MovieInfoResult.MovieInfo?, Never> = .init()
    
    var cancellables = Set<AnyCancellable>()
    var movieService = MovieService()
    
    func getMovieDetailResult(movieCd: String) async {
        let request = MovieEntity.Request(movieCd: movieCd)
        let movieResult = await movieService.getMovieInfo(request: request)
        
        switch movieResult {
        case .success(let success):
            self.movieDetailSubject.send(success.movieInfoResult.movieInfo)
        case .failure(_):
            self.movieDetailSubject.send(nil)
        }
    }
}
