//
//  Movie.swift
//  ororo
//
//  Created by Andrey Tsarevskiy on 23/07/2017.
//  Copyright © 2017 Andrey Tsarevskiy. All rights reserved.
//

import Foundation
import RealmSwift

class Movie: AbstractContent {
    
}

class MovieDetailed: Movie, DetailedContent {
    @objc dynamic var downloadUrl = ""
    var subtitles = List<Subtitle>()
    
    internal func setDownloadUrl(url: String) {
        downloadUrl = url
    }
    
    internal func getPreparedDownloadUrl() -> URL {
        return URL(string: downloadUrl)!
    }
    
    internal func getPreparedSubtitlesDownloadUrl(lang: String) -> URL {
        let subtitle = subtitles.filter {$0.lang == lang}.first
        return URL(string: subtitle!.url)!
    }
}
