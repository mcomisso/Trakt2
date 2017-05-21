//
//  MCMovie.swift
//  Trackr2
//
//  Created by Matteo Comisso on 20/05/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import Foundation
import SwiftyJSON

struct TMDBMovie: SerializableStruct {

    let id: Int

    let title: String
    let year: Int
    let traktId: Int

    let budget: String
    let genres: [String]
    let overview: String
    let releaseDate: String
    let revenue: Double
    let status: String // Released, etc
    let tagline: String
    let voteAvg: Double


    init(json: JSON, traktId: Int) throws {
        self.id = json["id"].intValue
        self.title = json["title"].stringValue
        self.year = json["year"].intValue

        self.traktId = traktId

        self.budget = json["budget"].stringValue
        self.genres = json["genres"].arrayValue.map{ $0.stringValue }
        self.overview = json["overview"].stringValue
        self.releaseDate = json["release_date"].stringValue
        self.revenue = json["revenue"].doubleValue
        self.status = json["status"].stringValue
        self.tagline = json["tagline"].stringValue
        self.voteAvg = json["vote_average"].doubleValue
    }

    var asDictionary: StandardDict {
        get {
            return [
                "id": self.id,
                "title": self.title,
                "year": self.year,
                "traktId": self.traktId,
                "budget": self.budget,
                "genres": self.genres,
                "overview": self.overview,
                "releaseDate": self.releaseDate,
                "revenue": self.revenue,
                "status": self.status,
                "tagline": self.tagline,
                "voteAvg": self.voteAvg
            ]
        }
    }

    init(data: StandardDict) {
        guard let id = data["id"] as? Int,
            let title = data["title"] as? String,
            let year = data["year"] as? Int,
            let traktId = data["traktId"] as? Int,
        let budget = data["budget"] as? String,
        let genres = data["genres"] as? [String],
        let overview = data["overview"] as? String,
        let releaseDate = data["releaseDate"] as? String,
        let revenue = data["revenue"] as? Double,
        let status = data["status"] as? String,
        let tagline = data["tagline"] as? String,
        let voteAvg = data["voteAvg"] as? Double

        else { fatalError() }

        self.id = id
        self.title = title
        self.year = year
        self.traktId = traktId

        self.budget = budget
        self.genres = genres
        self.overview = overview
        self.releaseDate = releaseDate
        self.revenue = revenue
        self.status = status
        self.tagline = tagline
        self.voteAvg = voteAvg
    }


}

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
            let coverURL = data["coverUrl"] as? String

        else { fatalError() }

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


//
//struct Person {
//    let name: String
//    let traktId: Int
//    let slug: String
//    let imdb: String
//    let tmdb: Int
//    let tvrage: Int
//
//    init(json: JSON) {
//        self.name = json["name"].stringValue
//        self.traktId = json["ids"]["trakt"].intValue
//        self.slug = json["ids"]["slug"].stringValue
//
//        self.imdb   = json["ids"]["imdb"].stringValue
//        self.tmdb   = json["ids"]["tmdb"].intValue
//        self.tvrage = json["ids"]["tvrage"].intValue
//    }
//    
//}
