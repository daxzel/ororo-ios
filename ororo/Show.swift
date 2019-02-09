//
//  Show.swift
//  ororo
//
//  Created by Andrey Tsarevskiy on 23/07/2017.
//  Copyright © 2017 Andrey Tsarevskiy. All rights reserved.
//

import Foundation
import RealmSwift

class Episode: Object, SimpleContent {
    @objc dynamic var id = -1
    @objc dynamic var name = ""
    @objc dynamic var plot = ""
    @objc dynamic var season = 1
    @objc dynamic var number = 1
    @objc dynamic var airdate = ""
    
    func copyFieldsTo(content: Episode) {
        content.id = id
        content.name = name
        content.plot = plot
        content.season = season
        content.number = number
        content.airdate = airdate
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

class Show: AbstractContent {
    
}

class ShowDetailed: Show {
    var episodes = List<Episode>()
}

class EpisodeDetailed: Episode, DetailedContent {
    @objc dynamic var downloadUrl = ""
    var subtitles = List<Subtitle>()
    
    internal func setDownloadUrl(url: String) {
        downloadUrl = url
    }
    
    internal func getPreparedDownloadUrl() -> URL {
        return URL(string: downloadUrl)!
    }
    
    internal func getPreparedSubtitlesDownloadUrl(lang: String = Settings.prefferedSubtitleCode) -> URL {
        var subtitle: Subtitle?
        if subtitle == .none {
            subtitle = subtitles.filter({ $0.lang == lang }).first
        }
        if subtitle == .none {
            subtitle = subtitles.filter({ $0.lang == Settings.defaultSubtitleCode }).first
        }
        if subtitle == .none {
            subtitle = subtitles.first
        }
        
        return URL(string: subtitle!.url)!
    }
}
