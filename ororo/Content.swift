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

class Content: Object {
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
    
    func copyFieldsTo(content: Content) {
        content.id = id
        content.name = name
        content.year = year
        content.countries = countries
        content.genres = genres
        content.desc = desc
        content.imdbRating = imdbRating
        content.posterThumb = posterThumb
        content.backdropUrl = backdropUrl
        content.poster = poster
    }
}

class Movie: Content {
    
}

class Episode: Object {
    dynamic var id = -1
    dynamic var name = ""
    dynamic var plot = ""
    dynamic var season = 1
    dynamic var number = 1
    dynamic var airdate = ""
}

class Show: Content {
    
}

class ShowDetailed: Show {
    var episodes = List<Episode>()
}

class MovieDetailed: Movie {
    dynamic var downloadUrl = ""
    var subtitles = List<Subtitle>()
    
    internal func getPreparedDownloadUrl() -> URL {
        return URL(string: downloadUrl)!
    }
    
    internal func getPreparedSubtitlesDownloadUrl(lang: String) -> URL {
        let subtitle = subtitles.filter {$0.lang == lang}.first
        return URL(string: subtitle!.url)!
    }
}

class DownloadedMovie: MovieDetailed {
    dynamic var isDownloadFinished = false
    
    internal override func getPreparedDownloadUrl() -> URL {
        return URL(fileURLWithPath: downloadUrl)
    }
    
    internal override func getPreparedSubtitlesDownloadUrl(lang: String) -> URL {
        let subtitle = subtitles.filter {$0.lang == lang}.first
        return URL(fileURLWithPath: subtitle!.url)
    }
}

