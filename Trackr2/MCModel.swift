//
//  MCModel.swift
//  Trackr2
//
//  Created by Matteo Comisso on 19/05/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import Foundation
import SwiftyJSON

//{
//    "title": "Batman Begins",
//    "year": 2005,
//    "ids": {
//        "trakt": 1,
//        "slug": "batman-begins-2005",
//        "imdb": "tt0372784",
//        "tmdb": 272
//    }
//}

struct Movie {
    let title: String
    let year: Int
    let trakt: Int
    let slug: String
    let imdb: String
    let tmdb: Int

    let coverURL: String? = nil

    init(json: JSON) throws {

        let movie = json["movie"]

        self.title = movie["title"].stringValue
        self.year = movie["year"].intValue

        self.trakt = movie["ids"]["trakt"].intValue
        self.slug = movie["ids"]["slug"].stringValue
        self.imdb = movie["ids"]["imdb"].stringValue
        self.tmdb = movie["ids"]["tmdb"].intValue
    }
}

//{
//    "name": "Bryan Cranston",
//    "ids": {
//        "trakt": 142,
//        "slug": "bryan-cranston",
//        "imdb": "nm0186505",
//        "tmdb": 17419,
//        "tvrage": 1797
//    }
//}


struct TMDBConfiguration {
    let baseUrl: String
    let secureBaseUrl: String

    let backdropSizes: [String]
    let logoSizes: [String]
    let posterSizes: [String]
    let profileSizes: [String]


    // Other keys unused

    init(json: JSON) throws {
        let images = json["images"]
        self.baseUrl = images["base_url"].stringValue
        self.secureBaseUrl = images["secure_base_url"].stringValue
        self.backdropSizes = images["backdrop_sizes"].arrayValue.map { $0.stringValue }
        self.logoSizes = images["logo_sizes"].arrayValue.map { $0.stringValue }
        self.posterSizes = images["poster_sizes"].arrayValue.map { $0.stringValue }
        self.profileSizes = images["profile_sizes"].arrayValue.map { $0.stringValue }
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
