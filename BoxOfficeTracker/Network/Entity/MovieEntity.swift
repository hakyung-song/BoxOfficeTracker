//
//  MovieEntity.swift
//  BoxOfficeTracker
//
//  Created by 송하경 on 2/23/24.
//

import Foundation

struct MovieEntity {
    struct Request: Encodable, JSONConvertible {
        let key: String = ServerConstant.key
        let movieCd: String
    }
    
    struct Response: Decodable {
        let movieInfoResult: MovieInfoResult
        
        struct MovieInfoResult: Decodable {
            let movieInfo: MovieInfo
            
            struct MovieInfo: Decodable {
                /// 영화명(국문)
                let movieNm: String?
                /// 개봉일
                let openDt: String?
                /// 상영시간
                let showTm: String?
                /// 장르명
                let genres: [Genre]?
                /// 감독
                let directors: [Director]?
                /// 배우
                let actors: [Actor]?
                /// 제작사
                let companys: [Company]?
                
                struct Genre: Decodable {
                    let genreNm: String?
                }
                
                struct Director: Decodable {
                    let peopleNm: String?
                }
                
                struct Actor: Decodable {
                    let peopleNm: String?
                    let cast: String?
                }
                
                struct Company: Decodable {
                    let companyCd: String?
                    let companyNm: String?
                    let companyPartNm: String?
                }
            }
        }
    }
}
