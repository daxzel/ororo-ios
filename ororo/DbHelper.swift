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
    
    static func readDownloadedMovie(_ id: String) -> DownloadedMovie? {
        let realm =  try! Realm()
        return realm
            .object(ofType: DownloadedMovie.self, forPrimaryKey: id)
    }
    
    static func readDownloadsFromDB() -> Results<DownloadedMovie> {
        print("Start reading downloaded movies:\n")
        return self.realm.objects(DownloadedMovie.self)
    }
    
    static func storeMovie(movie: Movie) {
        try! realm.write {
            self.realm.add(movie)
        }
    }
    
    static func update(updateBlock: (Void) -> Void) {
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
