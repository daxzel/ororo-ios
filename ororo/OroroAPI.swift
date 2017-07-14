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

protocol OroroAuthentificationProtocol {
    func authSuccessful()
    func authUnsuccessful()
    func connectionError()
}

class OroroAPI {
    
    static let moviesURL = "https://ororo.tv/api/v2/movies"
    static let movieURL = "https://ororo.tv/api/v2/movies/"
    static var email: String? = nil
    static var password: String? = nil
    
    static func setUpAuth(email: String, password: String) {
        self.email = email
        self.password = password
    }
    
    static func testAuthentication(email: String, password: String, hadler: OroroAuthentificationProtocol) {
        let header = getHeader(email: email, password: password)
        Alamofire.request(moviesURL, headers: header)
            .response(completionHandler: { (response) in
                if let statusCode = response.response?.statusCode {
                    switch(statusCode) {
                        case (401):
                            hadler.authUnsuccessful()
                        case _ where (statusCode >= 200 && statusCode < 300):
                            hadler.authSuccessful()
                        default:
                            hadler.connectionError()
                    }
                } else {
                    if response.error != nil {
                        hadler.connectionError()
                    }
                }
            })
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
    
    static func forAllMovies(completionHandler: @escaping (_ result: Result<Any>, [Movie]) -> Void) {
        
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
                        completionHandler(response.result, movies)
                    }
                case .failure(let error):
                    completionHandler(response.result, [])
                    print(error)
                }
                
        }
    }
    
    static internal func getHeader() -> HTTPHeaders {
        return getHeader(email: email!, password: password!)
    }
    
    static internal func getHeader(email: String, password: String) -> HTTPHeaders {
        var headers: HTTPHeaders = [:]
        if let authorizationHeader = Request.authorizationHeader(user: email, password: password) {
            headers[authorizationHeader.key] = authorizationHeader.value
        }
        return headers
    }

    static internal func parseMovie(json: JSON) -> Movie {
        let movie = Movie()
        parseMovieCommon(json: json, movie: movie)
        return movie
    }
    
    static internal func parseMovieDetailed(json: JSON) -> MovieDetailed {
        let movie = MovieDetailed()
        parseMovieCommon(json: json, movie: movie)
        movie.downloadUrl = json["download_url"].stringValue
        let subtitles = json["subtitles"].arrayValue.map { (json) -> Subtitle in
            let subtitle = Subtitle()
            subtitle.lang = json["lang"].stringValue
            subtitle.url = json["url"].stringValue
            return subtitle
        }
        movie.subtitles += subtitles
        return movie
    }
    
    static internal func parseMovieCommon(json: JSON, movie: Movie) {
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
    
}
