//
//  MovieDAO.swift
//  ororo
//
//  Created by Andrey Tsarevskiy on 18/07/2017.
//  Copyright © 2017 Andrey Tsarevskiy. All rights reserved.
//

import Foundation

import RealmSwift

class MovieDAO {
    
    static func getAll() -> Results<Movie> {
        let realm = try! Realm()
        return realm.objects(Movie.self)
    }
    
    static func saveAll(movies: [Movie]) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(movies)
        }
    }
    
    static func getDownloadedMovie(_ id: Int) -> DownloadedMovie? {
        let realm =  try! Realm()
        return realm
            .object(ofType: DownloadedMovie.self, forPrimaryKey: id)
    }
    
}
