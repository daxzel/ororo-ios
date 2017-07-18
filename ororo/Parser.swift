//
//  Parser.swift
//  ororo
//
//  Created by Andrey Tsarevskiy on 18/07/2017.
//  Copyright © 2017 Andrey Tsarevskiy. All rights reserved.
//

import Foundation
import SwiftyJSON

class Parser {
    
    static func parseMovieDetailed(json: JSON) -> MovieDetailed {
        let movie = MovieDetailed()
        parseContent(json: json, content: movie)
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
    
    static func parseContent(json: JSON, content: Content) {
        content.id = json["id"].stringValue
        content.name = json["name"].stringValue
        content.year = json["year"].stringValue
        content.desc = json["desc"].stringValue
        content.imdbRating = json["imdb_rating"].stringValue
        content.posterThumb = json["poster_thumb"].stringValue
        content.backdropUrl = json["backdrop_url"].stringValue
        content.poster = json["poster"].stringValue
        content.countries = json["array_countries"].arrayValue.map({$0.stringValue}).joined(separator: ", ")
        content.genres += json["array_genres"].arrayValue.map({$0.stringValue}).joined(separator: ", ")
    }
}