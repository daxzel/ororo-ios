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
    static let showsLoadedProperty = "showsLoaded"
    
    static func getMovies(completionHandler: @escaping (Results<Movie>) -> Void) {
        
        let moviesLoaded = defaults.bool(forKey: moviesLoadedProperty)
        
        if (moviesLoaded) {
            completionHandler(MovieDAO.getAll())
        } else {
            MovieAPI.getAllMovies { (result, movies) in
                switch (result) {
                case .success:
                    MovieDAO.saveAll(movies: movies)
                    defaults.set(true, forKey: moviesLoadedProperty)
                    completionHandler(MovieDAO.getAll())
                case .failure:
                    print("forAllMovies failure")
                }
            }
        }
    }
    
    static func getDownloads(completionHandler: @escaping (Results<DownloadedMovie>) -> Void) {
        
        completionHandler(DbHelper.readDownloadsFromDB())
    }
    
    static func getShows(completionHandler: @escaping (Results<Show>) -> Void) {
        
        let moviesLoaded = defaults.bool(forKey: showsLoadedProperty)
        
        if (moviesLoaded) {
            completionHandler(ShowDAO.getAll())
        } else {
            ShowAPI.getAllShows { (result, shows) in
                switch (result) {
                case .success:
                    ShowDAO.saveAll(shows: shows)
                    defaults.set(true, forKey: showsLoadedProperty)
                    completionHandler(ShowDAO.getAll())
                case .failure:
                    print("forAllMovies failure")
                }
            }
        }
        
    }
    
    static func clear() {
        defaults.set(false, forKey: moviesLoadedProperty)
    }

}
