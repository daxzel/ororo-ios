//
//  DbHelper.swift
//  ororo
//
//  Created by Andrey Tsarevskiy on 08/07/2017.
//  Copyright © 2017 Andrey Tsarevskiy. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift

class DbHelper {
    
    static let realm =  try! Realm()
    
    static func cleanDB() {
        try! realm.write {
            realm.deleteAll()
        }
        print("Finished DB clean\n")
    }
    
    static func readDownloadsFromDB() -> [DownloadedContent] {
        var downloads: [DownloadedContent] = []
        let movies = self.realm.objects(DownloadedMovie.self)
        movies.forEach { (downloaded) in
            downloads.append(downloaded)
        }
        let shows = self.realm.objects(DownloadedShow.self)
        shows.forEach { (downloaded) in
            downloads.append(downloaded)
        }
        return downloads
    }
    
    static func storeMovie(movie: Movie) {
        try! realm.write {
            self.realm.add(movie)
        }
    }
    
    static func update(updateBlock: () -> Void) {
        let realm =  try! Realm()
        try! realm.write {
            updateBlock()
        }
    }
    
    static func deleteDb() {
        let manager = FileManager.default
        let realmPath = Realm.Configuration.defaultConfiguration.fileURL!.absoluteURL.path
        let realmPaths = [
            realmPath as String,
            realmPath + ".lock",
            realmPath + ".man management"
        ]
        for path in realmPaths {
            do {
                try manager.removeItem(atPath: path)
            } catch {
                print("\(path) remove error")
            }
        }
    }

    
}
