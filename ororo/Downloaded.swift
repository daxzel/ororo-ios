//
//  Downloaded.swift
//  ororo
//
//  Created by Andrey Tsarevskiy on 23/07/2017.
//  Copyright © 2017 Andrey Tsarevskiy. All rights reserved.
//

import Foundation

// Show, Movie, Episode
protocol Downloaded {
    var isDownloadFinished: Bool { set get }
}

// Show and Movie
protocol DownloadedContent: Content, Downloaded {
}

class DownloadedMovie: MovieDetailed, DownloadedContent {
    dynamic var isDownloadFinished = false
    
    internal override func getPreparedDownloadUrl() -> URL {
        return URL(fileURLWithPath: downloadUrl)
    }
    
    internal override func getPreparedSubtitlesDownloadUrl(lang: String) -> URL {
        let subtitle = subtitles.filter {$0.lang == lang}.first
        return URL(fileURLWithPath: subtitle!.url)
    }
}

class DownloadedEpisode: EpisodeDetailed, Downloaded {
    dynamic var isDownloadFinished = false
    
    internal override func getPreparedDownloadUrl() -> URL {
        return URL(fileURLWithPath: downloadUrl)
    }
    
    internal override func getPreparedSubtitlesDownloadUrl(lang: String) -> URL {
        let subtitle = subtitles.filter {$0.lang == lang}.first
        return URL(fileURLWithPath: subtitle!.url)
    }
}


class DownloadedShow: Show, DownloadedContent {
    dynamic var isDownloadFinished = false
}
