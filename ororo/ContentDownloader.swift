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
        let request = try! URLRequest(url: movie.getPreparedDownloadUrl(), method: .get)
        
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!as NSURL
        
        let ororoDir = documentsUrl.appendingPathComponent("ororo/")!
        
        let filmUrl = ororoDir.appendingPathComponent("movie_\(movie.id).mp4")

        // Create object in DB
        let dMovie = DownloadedMovie()
        movie.copyFieldsTo(content: dMovie)
        dMovie.downloadUrl = filmUrl.path
        
        let progress = Alamofire.download(request) { (temporaryURL: URL, response: HTTPURLResponse) in
                (filmUrl, [.removePreviousFile, .createIntermediateDirectories])
        }.progress
        downloads[dMovie.id] = [progress]
        
        let subtitles = movie.subtitles.map { (subtile) -> Subtitle in
            let lang = subtile.lang
            let subtitleUrl = ororoDir.appendingPathComponent("subtitle_\(lang).srt")
            
            let request = try! URLRequest(url: movie.getPreparedSubtitlesDownloadUrl(lang: lang), method: .get)
            let subtitleProgress = Alamofire.download(request) { (temporaryURL: URL, response: HTTPURLResponse) in
                (subtitleUrl, [.removePreviousFile, .createIntermediateDirectories])
            }
            downloads[dMovie.id]?.append(subtitleProgress.progress)
            let result = Subtitle()
            result.lang = lang
            result.url = subtitleUrl.path
            return result
        }
            
        subtitles.forEach { (subtitle) in
            dMovie.subtitles.append(subtitle)
        }
        
        DbHelper.storeMovie(movie: dMovie)
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
