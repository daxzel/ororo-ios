//
//  MoviesProvider.swift
//  ororo
//
//  Created by Andrey Tsarevskiy on 12/07/2017.
//  Copyright © 2017 Andrey Tsarevskiy. All rights reserved.
//

import Foundation
import RealmSwift


protocol MoviesProviderProtocol {
    func getMovies(completionHandler: @escaping ([Movie]) -> Void)
}

