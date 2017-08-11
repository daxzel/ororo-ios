//
//  BackgroundDownloader.swift
//  ororo
//
//  Created by Tcarevskii, Andrei on 8/10/17.
//  Copyright © 2017 Andrey Tsarevskiy. All rights reserved.
//

import Foundation

import Alamofire
import RealmSwift

class BackgroundDownloader {
    
    static var jobsQueue: DispatchQueue? = nil
    static var downloads: [String:DownloadProgress] = [:]
    
    static func cleanDownloads() {
        downloads = [:]
    }
    
    static func processDownloadJobs() {
        let jobs = DownloadJobDAO.getDownloadJobs()
        jobs.filter { (job) -> Bool in
            job.id.range(of: MainDownloadJob.EPISODE_PREFIX) == nil
        }.forEach { (job) in
            if downloads[job.id] == nil {
                startJob(mainJob: job)
            }
        }
    }
    
    class DownloadProgress {
        var progress: Progress? = nil
        let onFinish: () -> Void
        var failed = false
    
        init(originalId: Int, prefix: String) {
    
            self.onFinish = { () in
                switch prefix {
                case MainDownloadJob.MOVIE_PREFIX:
                    DbHelper.update(updateBlock: { () in
                        let dMovie = MovieDAO.getDownloadedMovie(originalId)
                        dMovie?.isDownloadFinished = true
                    })
                case MainDownloadJob.EPISODE_PREFIX:
                    DbHelper.update(updateBlock: { () in
//                            let refreshedShow = ShowDAO.getDownloadedShow(id: showId)
                        let refreshedEpisode = ShowDAO.getDownloadedEpisode(originalId)
                        refreshedEpisode?.isDownloadFinished = true
//                            refreshedShow?.isDownloadFinished = true
                    })
                default: break
                }
            }
        }
    }
    
    
    static internal func startJob(mainJob: MainDownloadJob) -> Progress? {
        let progress = DownloadProgress(originalId: mainJob.originalId, prefix: mainJob.prefix)
        progress.progress = download(job: mainJob, downloadProgress: progress)
        var i: Int64 = 0
        mainJob.childJobs.forEach { (job) in
            if let episodeJob = job as? MainDownloadJob {
                let childProgress = startJob(mainJob: episodeJob)
                progress.progress?.addChild(childProgress!, withPendingUnitCount: i)
            } else {
                progress.progress?.addChild(download(job: mainJob, downloadProgress: progress), withPendingUnitCount: i)
            }
            i += 1
        }
        downloads[mainJob.id] = progress
        return progress.progress
    }
    
    static internal func download(job: DownloadJob, downloadProgress: DownloadProgress) -> Progress {
        let request = try! URLRequest(url: job.downloadUrl, method: .get)
        return Alamofire.download(request) { (temporaryURL: URL, response: HTTPURLResponse) in
            (URL(fileURLWithPath: job.filePath), [.removePreviousFile, .createIntermediateDirectories])
            }
            .validate()
            .response(completionHandler: { (response) in
                if (response.error != nil) {
                    downloadProgress.failed = true
                }
            }).progress
    }
    
    static internal func startAsync() {
        jobsQueue = DispatchQueue(label: "Content Downloader Jobs Queue")
        jobsQueue?.async {
            while(true) {
                sleep(3)
                downloads.forEach({ (download) in
                    notifyListener(identifier: download.0, downloadJob: download.1)
                })
            }
        }
    }
    
    static internal func notifyListener(identifier: String, downloadJob: DownloadProgress) {
        if let progress = downloadJob.progress {
            
            let fractionCompleted = progress.fractionCompleted
            let totalUnitCount = progress.totalUnitCount
            let completedUnitCount = progress.completedUnitCount
            
            if downloadJob.failed || totalUnitCount == 0 {
                return
            }
            
            if completedUnitCount >= totalUnitCount {
                downloadJob.onFinish()
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "downloadFinished" + identifier), object: nil)
                }
                
                self.downloads.removeValue(forKey: identifier)
            } else {
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "downloadProgress" + identifier), object: nil, userInfo: ["progress" : Int64(fractionCompleted * 100)])
                }
            }
        }
    }

}
