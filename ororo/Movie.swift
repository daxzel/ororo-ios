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
    dynamic var id = ""
    dynamic var name = ""
    dynamic var year = ""
    dynamic var countries = ""
    dynamic var genres = ""
    dynamic var desc = ""
    dynamic var imdbRating = ""
    dynamic var posterThumb = ""
    dynamic var backdropUrl = ""
    dynamic var poster = ""
}

class MovieDetailed: Movie {
    dynamic var downloadUrl = ""
}

