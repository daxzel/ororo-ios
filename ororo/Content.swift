//
//  Movie.swift
//  ororo
//
//  Created by Andrey Tsarevskiy on 05/07/2017.
//  Copyright © 2017 Andrey Tsarevskiy. All rights reserved.
//

import Foundation
import RealmSwift

protocol SimpleContent: class {
    var id: Int { set get }
}

protocol Content: SimpleContent {
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

class Subtitle: Object {
    @objc dynamic var url = ""
    @objc dynamic var lang = ""
}

// Show and Movie
class AbstractContent: Object, Content {
    @objc dynamic var id = -1
    @objc dynamic var name = ""
    @objc dynamic var year = ""
    @objc dynamic var countries = ""
    @objc dynamic var genres = ""
    @objc dynamic var desc = ""
    @objc dynamic var imdbRating = ""
    @objc dynamic var posterThumb = ""
    @objc dynamic var backdropUrl = ""
    @objc dynamic var poster = ""
    
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

// Episode and Movie
protocol DetailedContent {
    var subtitles: List<Subtitle> { get set }
    
    var downloadUrl: String { get set }
    
    func setDownloadUrl(url: String)
    
    func getPreparedDownloadUrl() -> URL
    
    func getPreparedSubtitlesDownloadUrl(lang: String) -> URL
}



