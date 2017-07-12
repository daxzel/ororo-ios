//
//  MovieNavigationController.swift
//  ororo
//
//  Created by Andrey Tsarevskiy on 09/07/2017.
//  Copyright © 2017 Andrey Tsarevskiy. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class RemoteMoviesProvider : MoviesProviderProtocol {
    func getMovies(completionHandler: @escaping ([Movie]) -> Void) {
        CacheHelper.getMovies { (movies) in
            completionHandler(Array(movies))
        }
    }
}

class MoviesNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        (topViewController as! MoviesViewController).moviesProvider = RemoteMoviesProvider()
    }
}
