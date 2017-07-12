//
//  CacheHelper.swift
//  ororo
//
//  Created by Andrey Tsarevskiy on 11/07/2017.
//  Copyright © 2017 Andrey Tsarevskiy. All rights reserved.
//

import Foundation
import RealmSwift


class CacheHelper {
    
    static let defaults = UserDefaults.standard
    static let moviesLoadedProperty = "moviesLoaded"
    
    static func getMovies(completionHandler: @escaping (Results<Movie>) -> Void) {
        
        let moviesLoaded = defaults.bool(forKey: moviesLoadedProperty)
        
        if (moviesLoaded) {
            completionHandler(DbHelper.readMoviesFromDB())
        } else {
            DbHelper.updateMovies { (Void) in
                defaults.set(true, forKey: moviesLoadedProperty)
                completionHandler(DbHelper.readMoviesFromDB())
            }
        }
    }
    
    static func getDownloads(completionHandler: @escaping (Results<DownloadedMovie>) -> Void) {
        
        completionHandler(DbHelper.readDownloadsFromDB())
    }
    
    static func clear() {
        defaults.set(false, forKey: moviesLoadedProperty)
    }

}
