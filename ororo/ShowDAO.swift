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

}
