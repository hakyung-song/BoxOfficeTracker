//
//  BoxOfficeListViewModel.swift
//  BoxOfficeTracker
//
//  Created by 송하경 on 2/23/24.
//

import Combine
import Foundation

class BoxOfficeListViewModel {
    var boxOfficeListSubject: PassthroughSubject<[BoxOfficeListEntity.Response.BoxOfficeResult.WeeklyBoxOffice], Never> = .init()
    
    var cancellables = Set<AnyCancellable>()
    var movieService = MovieService()
    
    func getBoxOfficeListResult(targetDate: String, weekGb: BoxOfficeListEntity.WeekGB) async {
        let request = BoxOfficeListEntity.Request(targetDt: targetDate, weekGb: weekGb.apiValue)
        let listResult = await movieService.getBoxOfficeList(request: request)
        
        switch listResult {
        case .success(let success):
            self.boxOfficeListSubject.send(success.boxOfficeResult.weeklyBoxOfficeList)
        case .failure(_):
            self.boxOfficeListSubject.send([])
        }
    }
}
