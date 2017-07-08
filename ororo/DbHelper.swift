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
    
    static func readMoviesFromDB() -> Results<Movie> {
        let realm =  try! Realm()
        print("Start reading movies:\n")
        return realm.objects(Movie.self)
    }
    
    static func updateMovies(completionHandler: @escaping (Void) -> Void) {
        let realm =  try! Realm()
        print("Start storing movies")
        OroroAPI.forAllMovies { (movies) in
            try! realm.write {
                realm.add(movies)
                print("\(movies.count) movies are stored\n")
            }
            completionHandler()
        }
    }

    
}
