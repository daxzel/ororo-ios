//
//  TVShowDao.swift
//  ororo
//
//  Created by Andrey Tsarevskiy on 18/07/2017.
//  Copyright © 2017 Andrey Tsarevskiy. All rights reserved.
//

import Foundation

import RealmSwift

class ShowDAO {
    
    static func getAll() -> Results<Show> {
        let realm = try! Realm()
        return realm.objects(Show.self)
    }
    
    static func saveAll(shows: [Show]) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(shows)
        }
    }
    
    static func saveShow(show: Show) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(show)
        }
    }
    
    static func getDetailedShow(id: Int) -> ShowDetailed? {
        let realm = try! Realm()
        return realm.object(ofType: ShowDetailed.self, forPrimaryKey: id)
    }
    
    static func saveEpisode(episode: Episode) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(episode)
        }
    }
    
    static func getDownloadedShow(id: Int) -> DownloadedShow? {
        let realm = try! Realm()
        return realm.object(ofType: DownloadedShow.self, forPrimaryKey: id)
    }
    
    static func getDownloadedEpisode(_ id: Int) -> DownloadedEpisode? {
        let realm =  try! Realm()
        return realm
            .object(ofType: DownloadedEpisode.self, forPrimaryKey: id)
    }
    
    static func updateShow(update:() -> Void) {
        let realm = try! Realm()
        try! realm.write {
            update()
        }
    }

}
