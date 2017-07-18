//
//  ShowsViewController.swift
//  ororo
//
//  Created by Andrey Tsarevskiy on 19/07/2017.
//  Copyright © 2017 Andrey Tsarevskiy. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class RemoteShowsProvider : ContentProviderProtocol {
    func getContent(completionHandler: @escaping ([Content]) -> Void) {
        CacheHelper.getShows { (shows) in
            completionHandler(Array(shows))
        }
    }
}

class ShowsNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        (topViewController as! ContentViewController).contentProvider = RemoteShowsProvider()
    }
}
