//
//  MCModel.swift
//  Trackr2
//
//  Created by Matteo Comisso on 19/05/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import Foundation
import SwiftyJSON

struct TMDBConfiguration: SerializableStruct {
    let baseUrl: String
    let secureBaseUrl: String

    let backdropSizes: [String]
    let logoSizes: [String]
    let posterSizes: [String]
    let profileSizes: [String]


    // Other keys unused

    init(data: Data) {
        let json = JSON(data: data)

        do {
            try self.init(json: json)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    init(json: JSON) throws {
        let images = json["images"]

        self.baseUrl        = images["base_url"].stringValue
        self.secureBaseUrl  = images["secure_base_url"].stringValue
        self.backdropSizes  = images["backdrop_sizes"].arrayValue.map { $0.stringValue }
        self.logoSizes      = images["logo_sizes"].arrayValue.map { $0.stringValue }
        self.posterSizes    = images["poster_sizes"].arrayValue.map { $0.stringValue }
        self.profileSizes   = images["profile_sizes"].arrayValue.map { $0.stringValue }
    }

    var asDictionary: StandardDict {
        get {
            return [
                "baseUrl": self.baseUrl,
                "secureBaseUrl": self.secureBaseUrl,
                "backdropSizes": self.backdropSizes,
                "logoSizes": self.logoSizes,
                "posterSizes": self.posterSizes,
                "profileSizes": self.profileSizes
            ]
        }
    }

    init(data: StandardDict) {
        guard let baseURL = data["baseUrl"] as? String,
            let secureBaseUrl = data["secureBaseUrl"] as? String,
            let backdropSizes = data["backdropSizes"] as? [String],
            let posterSizes = data["posterSizes"] as? [String],
            let profileSizes = data["profileSizes"] as? [String],
            let logoSizes = data["logoSizes"] as? [String]
            else { fatalError() }

        self.baseUrl = baseURL
        self.secureBaseUrl = secureBaseUrl
        self.backdropSizes = backdropSizes
        self.posterSizes = posterSizes
        self.profileSizes = profileSizes
        self.logoSizes = logoSizes
    }
}

