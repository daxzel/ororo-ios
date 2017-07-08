//
//  AppDelegate.swift
//  ororo
//
//  Created by Andrey Tsarevskiy on 01/03/2017.
//  Copyright © 2017 Andrey Tsarevskiy. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
       
//        cleanDB()
//        updateDB(completionHandler: { self.readFromDB() })
        return true
    }
    
    func cleanDB() {
        let realm =  try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
        print("Finished DB clean\n")
    }
    
    func readFromDB() {
        let realm =  try! Realm()
        print("Start reading movies:\n")
        realm.objects(Movie.self).forEach { (movie) in
            print("Name: \(movie.name)")
            print("Year: \(movie.year)")
            print("Description: \(movie.desc)")
            print("IMDB rating: \(movie.imdb_rating)")
            print("Poster: \(movie.poster_thumb)\n")
        }
    }
    
    func updateDB(completionHandler: @escaping (Void) -> Void) {
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

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

