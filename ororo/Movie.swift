//
//  Movie.swift
//  ororo
//
//  Created by Andrey Tsarevskiy on 05/07/2017.
//  Copyright © 2017 Andrey Tsarevskiy. All rights reserved.
//

import Foundation
import RealmSwift

class Movie: Object {
    dynamic var name = ""
    dynamic var year = ""
    dynamic var desc = ""
    dynamic var imdb_rating = ""
    dynamic var poster_thumb = ""
    dynamic var backdrop_url = ""
    dynamic var poster = ""
}
