//
//  Movie.swift
//  ororo
//
//  Created by Andrey Tsarevskiy on 05/07/2017.
//  Copyright © 2017 Andrey Tsarevskiy. All rights reserved.
//

import Foundation
import RealmSwift

class Subtitle: Object {
    dynamic var url = ""
    dynamic var lang = ""
}

class Movie: Object {
    dynamic var id = ""
    dynamic var name = ""
    dynamic var year = ""
    dynamic var countries = ""
    dynamic var genres = ""
    dynamic var desc = ""
    dynamic var imdbRating = ""
    dynamic var posterThumb = ""
    dynamic var backdropUrl = ""
    dynamic var poster = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

class MovieDetailed: Movie {
    dynamic var downloadUrl = ""
    var subtitles = List<Subtitle>()
}

class DownloadedMovie: MovieDetailed {
//    dynamic var movie: Movie? = nil
//    dynamic var filePath = ""
//    dynamic var subtitlesPath = ""
}

