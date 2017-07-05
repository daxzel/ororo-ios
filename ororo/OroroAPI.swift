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
    static let user = "test@example.com"
    static let password = "password"
    
    static func parseMovie(json: JSON) -> Movie {
        let movie = Movie()
        movie.name = json["name"].stringValue
        movie.year = json["year"].stringValue
        movie.desc = json["desc"].stringValue
        movie.imdb_rating = json["imdb_rating"].stringValue
        movie.poster_thumb = json["poster_thumb"].stringValue
        movie.backdrop_url = json["backdrop_url"].stringValue
        movie.poster = json["poster"].stringValue
        return movie
    }
    
    static func forAllMovies(completionHandler: @escaping ([Movie]) -> Void) {
        
        var headers: HTTPHeaders = [:]
        
        if let authorizationHeader = Request.authorizationHeader(user: user, password: password) {
            headers[authorizationHeader.key] = authorizationHeader.value
        }
        
        Alamofire.request(moviesURL, headers: headers)
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
