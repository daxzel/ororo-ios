//
//  DownloadsNavigationController.swift
//  ororo
//
//  Created by Andrey Tsarevskiy on 12/07/2017.
//  Copyright © 2017 Andrey Tsarevskiy. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift


class DownloadsProvider : MoviesProviderProtocol {
    func getMovies(completionHandler: @escaping ([Movie]) -> Void) {
        CacheHelper.getDownloads{ (movies) in
            completionHandler(Array(movies))
        }
    }
}

class DownloadsNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        (topViewController as! MoviesViewController).moviesProvider = DownloadsProvider()
    }
}
