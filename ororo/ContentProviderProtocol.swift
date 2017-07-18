//
//  MoviesProvider.swift
//  ororo
//
//  Created by Andrey Tsarevskiy on 12/07/2017.
//  Copyright © 2017 Andrey Tsarevskiy. All rights reserved.
//

import Foundation
import RealmSwift


protocol ContentProviderProtocol {
    func getContent(completionHandler: @escaping ([Content]) -> Void)
}

