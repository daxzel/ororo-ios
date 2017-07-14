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
    static var downloads: [String:Progress] = [:]
    static var listeners: [String:ContentDownloadListenerProtocol] = [:]
    
    static func load(url: URL, movie: Movie) {
        let request = try! URLRequest(url: url, method: .get)
        
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!as NSURL
        let toUrl = documentsUrl.appendingPathComponent("movie_\(movie.id)")!

        // Create object in DB
        let dMovie = DownloadedMovie()
        movie.copyFieldsTo(movie: dMovie)
        dMovie.downloadUrl = toUrl.absoluteString
        DbHelper.storeMovie(movie: dMovie)
        
        let progress = Alamofire.download(request) { (temporaryURL: URL, response: HTTPURLResponse) in
                (toUrl, [.removePreviousFile, .createIntermediateDirectories])
        }.progress
        
        downloads[dMovie.id] = progress
    }
    
    static func subscribeToDownloadProgress(id: String, listener : ContentDownloadListenerProtocol) {
        startAsyncIfNotStarted()
        listeners[id] = listener
        if let download = downloads[id] {
            notifyListener(id: id, download: download)
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
                            notifyListener(id: download.0, download: download.1)
                        })
                    }
                }
            }
        }
    }
    
    static internal func notifyListener(id: String, download: Progress) {
        let fractionCompleted = download.fractionCompleted
        let totalUnitCount = download.totalUnitCount
        let completedUnitCount = download.completedUnitCount
        if completedUnitCount >= totalUnitCount {
            downloads.removeValue(forKey: id)
            if let listener = listeners[id] {
                listener.finished()
                listeners.removeValue(forKey: id)
            }
        } else {
            if let listener = listeners[id] {
                listener.updateProgress(percent: Int64(fractionCompleted * 100))
            }
        }
    }
    
}
