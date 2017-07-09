//
//  OroroAPI.swift
//  ororo
//
//  Created by Andrey Tsarevskiy on 05/07/2017.
//  Copyright © 2017 Andrey Tsarevskiy. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class OroroAPI {
    
    static let moviesURL = "https://ororo.tv/api/v2/movies"
    static let movieURL = "https://ororo.tv/api/v2/movies/"
    static let user = "test@example.com"
    static let password = "password"
    
    static func parseMovieCommon(json: JSON, movie: Movie) {
        movie.id = json["id"].stringValue
        movie.name = json["name"].stringValue
        movie.year = json["year"].stringValue
        movie.desc = json["desc"].stringValue
        movie.imdbRating = json["imdb_rating"].stringValue
        movie.posterThumb = json["poster_thumb"].stringValue
        movie.backdropUrl = json["backdrop_url"].stringValue
        movie.poster = json["poster"].stringValue
        movie.countries = json["array_countries"].arrayValue.map({$0.stringValue}).joined(separator: ", ")
        movie.genres += json["array_genres"].arrayValue.map({$0.stringValue}).joined(separator: ", ")
    }
    
    
    static func parseMovie(json: JSON) -> Movie {
        let movie = Movie()
        parseMovieCommon(json: json, movie: movie)
        return movie
    }
    
    static func parseMovieDetailed(json: JSON) -> MovieDetailed {
        let movie = MovieDetailed()
        parseMovieCommon(json: json, movie: movie)
        movie.downloadUrl = json["download_url"].stringValue
        return movie
    }
    
    static func getHeader() -> HTTPHeaders {
        var headers: HTTPHeaders = [:]
        if let authorizationHeader = Request.authorizationHeader(user: user, password: password) {
            headers[authorizationHeader.key] = authorizationHeader.value
        }
        return headers
    }
    
    static func forOneMovie(id: String, completionHandler: @escaping (MovieDetailed) -> Void) {
        
        Alamofire.request(movieURL + id, headers: getHeader())
            .responseJSON { response in
                switch response.result {
                case .success:
                    if let data = response.data {
                        print("Data recieved: \(data)")
                        let movieJSON = JSON(data: data)
                        completionHandler(parseMovieDetailed(json: movieJSON))
                    }
                case .failure(let error):
                    print(error)
            }
                
        }
    }
    
    static func forAllMovies(completionHandler: @escaping ([Movie]) -> Void) {
        
        Alamofire.request(moviesURL, headers: getHeader())
            .responseJSON { response in
                switch response.result {
                case .success:
                    if let data = response.data {
                        print("Data recieved: \(data)")
                        let moviesJSON = JSON(data: data)["movies"]
                        let movies = moviesJSON.arrayValue.map({ (json) -> Movie in
                            return parseMovie(json: json)
                        })
                        completionHandler(movies)
                    }
                case .failure(let error):
                    print(error)
                }
                
        }
    }

    
}
