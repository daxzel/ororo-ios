//
//  MovieAPI.swift
//  ororo
//
//  Created by Andrey Tsarevskiy on 18/07/2017.
//  Copyright © 2017 Andrey Tsarevskiy. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class MovieAPI {
    
    static let moviesURL = "https://ororo.tv/api/v2/movies"
    static let movieURL = "\(moviesURL)/"
    
    static func getAllMovies(completionHandler: @escaping (_ result: Result<Any>, [Movie]) -> Void) {
        
        Alamofire.request(moviesURL, headers: OroroAPI.getHeader())
            .responseJSON { response in
                switch response.result {
                case .success:
                    if let data = response.data {
                        let moviesJSON = JSON(data: data)["movies"]
                        let movies = moviesJSON.arrayValue.map({ (json) -> Movie in
                            let movie = Movie()
                            Parser.parseContent(json: json, content: movie)
                            return movie
                        })
                        completionHandler(response.result, movies)
                    }
                case .failure(let error):
                    completionHandler(response.result, [])
                    print(error)
                }
                
        }
    }
    
    static func forOneMovie(id: Int, completionHandler: @escaping (MovieDetailed) -> Void) {
        
        Alamofire.request(movieURL + String(id), headers: OroroAPI.getHeader())
            .responseJSON { response in
                switch response.result {
                case .success:
                    if let data = response.data {
                        let movieJSON = JSON(data: data)
                        completionHandler(Parser.parseMovieDetailed(json: movieJSON))
                    }
                case .failure(let error):
                    print(error)
                }
                
        }
    }
    
}
