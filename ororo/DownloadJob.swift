//
//  DownloadJob.swift
//  ororo
//
//  Created by Tcarevskii, Andrei on 8/10/17.
//  Copyright © 2017 Andrey Tsarevskiy. All rights reserved.
//

import Foundation


import Foundation
import RealmSwift

class DownloadJob: Object {
    @objc dynamic var downloadUrl = ""
    @objc dynamic var filePath = ""
    @objc dynamic var isFinished = false
}

class MainDownloadJob: DownloadJob {
    
    static let EPISODE_PREFIX = "episode"
    static let MOVIE_PREFIX = "movie"
    static let SHOW_PREFIX = "show"
    
    @objc dynamic var id = ""
    @objc dynamic var prefix = ""
    @objc dynamic var originalId = -1
    
    var childJobs = List<DownloadJob>()
    var mainJobs = List<MainDownloadJob>()
    
    func getJobs() -> [DownloadJob] {
        var jobs: [DownloadJob] = []
     
        jobs.append(contentsOf: childJobs)
        jobs.append(contentsOf: mainJobs.map { (job) -> DownloadJob in
            job
        })
        
        return jobs
    }
    
    internal func initialize(content: SimpleContent) {
        id = MainDownloadJob.getId(content: content)
        prefix = MainDownloadJob.getPrefix(content: content)
        originalId = content.id
    }
    
    static internal func getId(content: SimpleContent) -> String {
        return getPrefix(content: content) + String(content.id)
    }
    
    static internal func getPrefix(content: SimpleContent) -> String {
        switch content {
        case is Show:
            return SHOW_PREFIX
        case is Movie:
            return MOVIE_PREFIX
        case is Episode:
            return EPISODE_PREFIX
        default:
            return "unknown"
        }
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
