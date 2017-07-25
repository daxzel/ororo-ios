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

// Show and Movie
class AbstractContent: Object, Content {
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
    
    func copyFieldsTo(content: AbstractContent) {
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

protocol Content: class {
    var id: String { set get }
    var name: String { set get }
    var year: String { set get }
    var countries: String { set get }
    var genres: String { set get }
    var desc: String { set get }
    var imdbRating: String { set get }
    var posterThumb: String { set get }
    var backdropUrl: String { set get }
    var poster: String { set get }
}

// Episode and Movie
protocol DetailedContent {
    var subtitles: List<Subtitle> { get set }
    
    var downloadUrl: String { get set }
    
    func setDownloadUrl(url: String)
    
    func getPreparedDownloadUrl() -> URL
    
    func getPreparedSubtitlesDownloadUrl(lang: String) -> URL
}



