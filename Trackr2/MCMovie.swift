//
//  MCMovie.swift
//  Trackr2
//
//  Created by Matteo Comisso on 20/05/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Movie: Object {
    // Let's use tmdb as pk to unify both apis
    dynamic var tmdb: Int = 0

    dynamic var trendingIndex: Int = 0

    dynamic var title: String = ""
    dynamic var year: Int = 0
    dynamic var trakt: Int = 0
    dynamic var slug: String = ""
    dynamic var imdb: String = ""

    dynamic var budget: String = ""
    dynamic var overview: String = ""
    dynamic var releaseDate: String = ""
    dynamic var revenue: Double = 0.0
    dynamic var status: String = "" // Released, etc
    dynamic var tagline: String = ""
    dynamic var voteAvg: Double = 0.0

    convenience init(json: JSON) throws {

        self.init()

        let movie = json["movie"]

        self.title = movie["title"].stringValue
        self.year = movie["year"].intValue

        self.trakt = movie["ids"]["trakt"].intValue
        self.slug = movie["ids"]["slug"].stringValue
        self.imdb = movie["ids"]["imdb"].stringValue
        self.tmdb = movie["ids"]["tmdb"].intValue
    }

    func saveTMDBDetails(json: JSON) {
        self.budget = json["budget"].stringValue
        self.overview = json["overview"].stringValue
        self.releaseDate = json["release_date"].stringValue
        self.revenue = json["revenue"].doubleValue
        self.status = json["status"].stringValue
        self.tagline = json["tagline"].stringValue
        self.voteAvg = json["vote_average"].doubleValue
    }

    override class func primaryKey() -> String? { return "tmdb" }
    
}
