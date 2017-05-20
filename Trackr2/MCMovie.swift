//
//  MCMovie.swift
//  Trackr2
//
//  Created by Matteo Comisso on 20/05/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Movie: SerializableStruct {
    let title: String
    let year: Int
    let trakt: Int
    let slug: String
    let imdb: String
    let tmdb: Int

    var coverURL: String

    init(json: JSON) throws {

        let movie = json["movie"]

        self.title = movie["title"].stringValue
        self.year = movie["year"].intValue

        self.trakt = movie["ids"]["trakt"].intValue
        self.slug = movie["ids"]["slug"].stringValue
        self.imdb = movie["ids"]["imdb"].stringValue
        self.tmdb = movie["ids"]["tmdb"].intValue

        self.coverURL = ""
    }

    mutating func setCoverURL(_ coverURL: String) {
        self.coverURL = coverURL
    }

    // MARK: SerializableStruct

    init(data: StandardDict) {
        guard let title = data["title"] as? String,
            let year = data["year"] as? Int,
            let trakt = data["trakt"] as? Int,
            let slug = data["slug"] as? String,
            let imdb = data["imdb"] as? String,
            let tmdb = data["tmdb"] as? Int,
            let coverURL = data["coverUrl"] as? String else { fatalError() }

        self.title = title
        self.year = year
        self.trakt = trakt
        self.slug = slug
        self.imdb = imdb
        self.tmdb = tmdb

        self.coverURL = coverURL
    }

    var asDictionary: StandardDict {
        get {
            return [
                "title": self.title,
                "year": self.year,
                "trakt": self.trakt,
                "slug": self.slug,
                "imdb": self.imdb,
                "tmdb": self.tmdb,
                "coverUrl": self.coverURL
            ]
        }
    }
}



struct Person {
    let name: String
    let traktId: Int
    let slug: String
    let imdb: String
    let tmdb: Int
    let tvrage: Int

    init(json: JSON) {
        self.name = json["name"].stringValue
        self.traktId = json["ids"]["trakt"].intValue
        self.slug = json["ids"]["slug"].stringValue

        self.imdb   = json["ids"]["imdb"].stringValue
        self.tmdb   = json["ids"]["tmdb"].intValue
        self.tvrage = json["ids"]["tvrage"].intValue
    }
    
}
