//
//  MCMovie.swift
//  Trackr2
//
//  Created by Matteo Comisso on 20/05/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import Foundation
import SwiftyJSON


final class Movie: Equatable {
    let title: String
    let year: Int
    let trakt: Int
    let slug: String
    let imdb: String
    let tmdb: Int

    // MARK: Equatable

    static func ==(lhs: Movie, rhs: Movie) -> Bool {
        return lhs.imdb == rhs.imdb
    }

    // MARK: Initialization

    init(json: JSON) throws {

        let movie = json["movie"]

        self.title = movie["title"].stringValue
        self.year = movie["year"].intValue

        self.trakt = movie["ids"]["trakt"].intValue
        self.slug = movie["ids"]["slug"].stringValue
        self.imdb = movie["ids"]["imdb"].stringValue
        self.tmdb = movie["ids"]["tmdb"].intValue

    }

    // MARK: SerializableStruct

    init(data: StandardDict) {
        guard let title = data["title"] as? String,
            let year = data["year"] as? Int,
            let trakt = data["trakt"] as? Int,
            let slug = data["slug"] as? String,
            let imdb = data["imdb"] as? String,
            let tmdb = data["tmdb"] as? Int
            else { fatalError() }

        self.title = title
        self.year = year
        self.trakt = trakt
        self.slug = slug
        self.imdb = imdb
        self.tmdb = tmdb
    }

    var asDictionary: StandardDict {
        get {
            return [
                "title": self.title,
                "year": self.year,
                "trakt": self.trakt,
                "slug": self.slug,
                "imdb": self.imdb,
                "tmdb": self.tmdb
            ]
        }
    }
}
