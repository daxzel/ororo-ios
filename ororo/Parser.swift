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
    
    static func parseEpisodeDetailed(json: JSON) -> EpisodeDetailed {
        let episode = EpisodeDetailed()
        parseEpisode(episode: episode, json: json)
        episode.downloadUrl = json["download_url"].stringValue
        let subtitles = getSubtitles(json: json)
        episode.subtitles += subtitles
        return episode
    }
    
    static func parseShowDetailed(json: JSON) -> ShowDetailed {
        let show = ShowDetailed()
        parseContent(json: json, content: show)
        let episodes = json["episodes"].arrayValue.map { (json) -> Episode in
            let episode = Episode()
            parseEpisode(episode: episode, json: json)
            return episode
        }
        show.episodes += episodes
        return show
    }
    
    static func parseMovieDetailed(json: JSON) -> MovieDetailed {
        let movie = MovieDetailed()
        parseContent(json: json, content: movie)
        movie.downloadUrl = json["download_url"].stringValue
        let subtitles = getSubtitles(json: json)
        movie.subtitles += subtitles
        return movie
    }
    
    static internal func parseEpisode(episode: Episode, json: JSON) {
        episode.id = json["id"].intValue
        episode.name = json["name"].stringValue
        episode.plot = json["plot"].stringValue
        episode.season = json["season"].intValue
        episode.number = json["number"].intValue
        episode.airdate = json["airdate"].stringValue
    }
    
    static internal func parseContent(json: JSON, content: Content) {
        content.id = json["id"].intValue
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
    
    static internal func getSubtitles(json: JSON) -> [Subtitle] {
        return Array(json["subtitles"].arrayValue.map { (json) -> Subtitle in
            let subtitle = Subtitle()
            subtitle.lang = json["lang"].stringValue
            subtitle.url = json["url"].stringValue
            return subtitle
        })
    }
}
