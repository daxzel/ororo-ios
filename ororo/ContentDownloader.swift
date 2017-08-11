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
    
    static func load(movie: MovieDetailed) {
        
        let dMovie = DownloadedMovie()
        movie.copyFieldsTo(content: dMovie)
        dMovie.isDownloadFinished = false
        
        let downloadJob = MainDownloadJob()
        downloadJob.initialize(content: movie)
        let contentDir = getDocumentDir().appendingPathComponent("ororo/\(downloadJob.id)/")
        
        load(downloadFrom: movie,
             downloadTo: dMovie,
             contentDir: contentDir,
             mainDownloadJob: downloadJob)
        
        DownloadJobDAO.saveDownloadJob(job: downloadJob)
        DbHelper.storeMovie(movie: dMovie)
        BackgroundDownloader.processDownloadJobs()
    }
    
    static func load(show: Show, episode: EpisodeDetailed) {
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
        episode.copyFieldsTo(content: dEpisode)
        
        let showDownloadJob = DownloadJobDAO.getDownloadJob(MainDownloadJob.getId(content: show)) ?? MainDownloadJob()
        
        showDownloadJob.initialize(content: show)
        
        let episodeDownloadJob = MainDownloadJob()
        episodeDownloadJob.initialize(content: episode)
        showDownloadJob.childJobs.append(episodeDownloadJob)
        
        let contentDir = getDocumentDir().appendingPathComponent("ororo/\(episodeDownloadJob.id)/")
        
        load(downloadFrom: episode,
             downloadTo: dEpisode,
             contentDir: contentDir,
             mainDownloadJob: episodeDownloadJob)
        
        DownloadJobDAO.saveDownloadJob(job: showDownloadJob)
        ShowDAO.saveEpisode(episode: dEpisode)
        BackgroundDownloader.processDownloadJobs()
    }
    
    static internal func getDocumentDir() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! as URL
    }
    
    static internal func load(downloadFrom: DetailedContent, downloadTo: DetailedContent, contentDir: URL, mainDownloadJob: MainDownloadJob) {
        
        let contentUrl = contentDir.appendingPathComponent("content.mp4")
        downloadTo.setDownloadUrl(url: contentUrl.path)
        mainDownloadJob.downloadUrl = downloadFrom.downloadUrl
        mainDownloadJob.filePath = contentUrl.path
        
        loadSubtitles(downloadFrom: downloadFrom,
                      downloadTo: downloadTo,
                      contentDir: contentDir,
                      mainDownloadJob: mainDownloadJob)
    }
    
    static internal func loadSubtitles(downloadFrom: DetailedContent, downloadTo: DetailedContent, contentDir: URL, mainDownloadJob: MainDownloadJob) {
        let subtitles = downloadFrom.subtitles.map { (subtile) -> Subtitle in
            let lang = subtile.lang
            let subtitleUrl = contentDir.appendingPathComponent("subtitle_\(lang).srt")
            
            let downloadJob = DownloadJob()
            downloadJob.downloadUrl = downloadFrom.getPreparedSubtitlesDownloadUrl(lang: lang).absoluteString
            downloadJob.filePath = subtitleUrl.path
            mainDownloadJob.childJobs.append(downloadJob)
            
            let result = Subtitle()
            result.lang = lang
            result.url = subtitleUrl.path
            return result
        }
        subtitles.forEach { (subtitle) in
            downloadTo.subtitles.append(subtitle)
        }
    }
    
    static func subscribeToDownloadProgress(requester: SimpleContent, listener : ContentDownloadListenerProtocol) {
        
        let identifier = MainDownloadJob.getId(content: requester)
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "downloadProgress" + identifier), object: nil, queue: nil, using: { (notify) in
                if let progress = notify.userInfo?["progress"] as? Int64 {
                    listener.updateProgress(percent: progress)
                }
                                                
            });
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "downloadFinished" + identifier), object: nil, queue: nil, using: { _ in listener.finished() });
    }
    
}
