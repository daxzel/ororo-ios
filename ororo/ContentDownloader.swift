//
//  ContentDownloader.swift
//  ororo
//
//  Created by Andrey Tsarevskiy on 11/07/2017.
//  Copyright © 2017 Andrey Tsarevskiy. All rights reserved.
//

import Foundation
import Alamofire

protocol ContentDownloadListenerProtocol {
    func updateProgress(percent: Int64)
    func finished()
}

class ContentDownloader {
    
    static var jobsQueue: DispatchQueue? = nil
    static var downloads: [String:[Progress]] = [:]
    static var listeners: [String:ContentDownloadListenerProtocol] = [:]
    
    static func load(movie: MovieDetailed) {
        
        let prefix = "movie"
        
        let dMovie = DownloadedMovie()
        movie.copyFieldsTo(content: dMovie)
        dMovie.isDownloadFinished = false
        
        load(prefix: prefix, id: movie.id, detailedToDownload: movie, result: dMovie)
        
        DbHelper.storeMovie(movie: dMovie)
    }
    
    static func load(show: Show, episode: EpisodeDetailed) {
        let prefix = "episode"
        
        var dShow = ShowDAO.getDownloadedShow(id: show.id)
        
        if (dShow == nil) {
            dShow = DownloadedShow()
            show.copyFieldsTo(content: dShow!)
            ShowDAO.saveShow(show: dShow!)
        }
        
        ShowDAO.updateShow {
            dShow?.isDownloadFinished = false
        }
        
        let dEpisode = DownloadedEpisode()
        
        load(prefix: prefix, id: dShow!.id, detailedToDownload: episode, result: dEpisode)
        
        ShowDAO.saveEpisode(episode: dEpisode)
    }
    
    static internal func load(prefix: String, id: String, detailedToDownload: DetailedContent,
                    result: DetailedContent) {
        
        let request = try! URLRequest(url: detailedToDownload.getPreparedDownloadUrl(), method: .get)
        
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!as NSURL
        
        let contentDir = documentsUrl.appendingPathComponent("ororo/\(prefix)_\(id)/")!
        
        let contentUrl = contentDir.appendingPathComponent("content.mp4")
        
        result.setDownloadUrl(url: contentUrl.path)
        
        let progress = Alamofire.download(request) { (temporaryURL: URL, response: HTTPURLResponse) in
            (contentUrl, [.removePreviousFile, .createIntermediateDirectories])
            }.progress
        downloads[id] = [progress]
        
        loadSubtitles(id: id, detailed: detailedToDownload, contentDir: contentDir)
    
    }
    
    static internal func loadSubtitles(id: String, detailed: DetailedContent, contentDir: URL) {
        let subtitles = detailed.subtitles.map { (subtile) -> Subtitle in
            let lang = subtile.lang
            let subtitleUrl = contentDir.appendingPathComponent("subtitle_\(lang).srt")
            
            let request = try! URLRequest(url: detailed.getPreparedSubtitlesDownloadUrl(lang: lang), method: .get)
            let subtitleProgress = Alamofire.download(request) { (temporaryURL: URL, response: HTTPURLResponse) in
                (subtitleUrl, [.removePreviousFile, .createIntermediateDirectories])
            }
            downloads[id]?.append(subtitleProgress.progress)
            let result = Subtitle()
            result.lang = lang
            result.url = subtitleUrl.path
            return result
        }
        subtitles.forEach { (subtitle) in
            detailed.subtitles.append(subtitle)
        }
    }
    
    static func subscribeToDownloadProgress(id: String, listener : ContentDownloadListenerProtocol) {
        startAsyncIfNotStarted()
        listeners[id] = listener
        if let download = downloads[id] {
            notifyListener(id: id, progresses: download)
        }
    }
    
    static internal func startAsyncIfNotStarted() {
        if (jobsQueue == nil) {
            jobsQueue = DispatchQueue(label: "Content Downloader Jobs Queue")
            jobsQueue?.async {
                while(true) {
                    sleep(2)
                    DispatchQueue.global().async {
                        downloads.forEach({ (download) in
                            notifyListener(id: download.0, progresses: download.1)
                        })
                    }
                }
            }
        }
    }
    
    static internal func notifyListener(id: String, progresses: [Progress]) {
        let filmDownload = progresses[0]
        
        let fractionCompleted = filmDownload.fractionCompleted
        let totalUnitCount = filmDownload.totalUnitCount
        let completedUnitCount = filmDownload.completedUnitCount
        
        if completedUnitCount >= totalUnitCount {
            let allDownloadsCompleted = progresses.reduce(true, { (result, progress) -> Bool in
                return result && (progress.completedUnitCount >= progress.totalUnitCount)
            })
            if (allDownloadsCompleted) {
                self.downloads.removeValue(forKey: id)
                if let listener = listeners[id] {
                    let move = DbHelper.readDownloadedMovie(id)
                    DbHelper.update(updateBlock: { () in
                        move?.isDownloadFinished = true
                    })
                    listener.finished()
                    listeners.removeValue(forKey: id)
                }
            }
        } else {
            if let listener = listeners[id] {
                listener.updateProgress(percent: Int64(fractionCompleted * 100))
            }
        }
    }
    
}
