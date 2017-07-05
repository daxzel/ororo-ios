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
       
//        updateDB()
        readFromDb()
        return true
    }
    
    func readFromDb() {
        let realm =  try! Realm()
        print("Start to read movies")
        realm.objects(Movie.self).forEach { (movie) in
            print(movie.name)
        }
        print("Finish to read movies")
    }
    
    func updateDB() {
        let user = "test@example.com"
        let password = "password"
        
        var headers: HTTPHeaders = [:]
        
        if let authorizationHeader = Request.authorizationHeader(user: user, password: password) {
            headers[authorizationHeader.key] = authorizationHeader.value
        }
        
        let realm =  try! Realm()
        
        let moviesURL = "https://ororo.tv/api/v2/movies"
        Alamofire.request(moviesURL, headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success:
                    if let data = response.data {
                        print(data)
                        let moviesJSON = JSON(data: data)
                        let movieNames = moviesJSON["movies"].arrayValue.map({$0["name"].stringValue})
                        
                        try! realm.write {
                            for movieName in movieNames {
                                let movie = Movie()
                                movie.name = movieName
                                realm.add(movie)
                                print(movieName)
                            }
                        }
                        
                    }
                case .failure(let error):
                    print(error)
                }
                
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

