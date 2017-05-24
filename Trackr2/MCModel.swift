//
//  MCModel.swift
//  Trackr2
//
//  Created by Matteo Comisso on 19/05/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import Foundation
import SwiftyJSON
import TMDBSwift

extension ConfigurationMDB: SerializableStruct {
    var asDictionary: StandardDict {
        get {
            return [
                "base_url": self.base_url,
                "secure_base_url": self.secure_base_url,
                "backdrop_sizes": self.backdrop_sizes,
                "poster_sizes": self.poster_sizes,
                "profile_sizes": self.profile_sizes,
                "logo_sizes": self.logo_sizes,
                "change_keys": self.change_keys,
                "still_sizes": self.still_sizes
            ]
        }
    }

    init?(data: StandardDict) {
        guard let baseURL = data["base_url"] as? String,
            let secureBaseUrl = data["secure_base_url"] as? String,
            let backdropSizes = data["backdrop_sizes"] as? [String],
            let posterSizes = data["poster_sizes"] as? [String],
            let profileSizes = data["profile_sizes"] as? [String],
            let logoSizes = data["logo_sizes"] as? [String],
            let change_keys = data["change_keys"] as? [String],
            let still_sizes = data["still_sizes"] as? [String]
            else { return nil }

        self.base_url = baseURL
        self.secure_base_url = secureBaseUrl
        self.backdrop_sizes = backdropSizes
        self.poster_sizes = posterSizes
        self.profile_sizes = profileSizes
        self.logo_sizes = logoSizes
        self.change_keys = change_keys
        self.still_sizes = still_sizes
    }


    func generatePosterUrl(secure: Bool, dimension: TMDBImageDimension = .big) -> URL {
        guard let baseURL = secure ? URL(string: self.secure_base_url) : URL(string: self.base_url),
        let size = dimension == .small ? self.poster_sizes.first : self.poster_sizes.last else { fatalError() }
        return baseURL.appendingPathComponent(size)
    }
}

enum TMDBImageDimension {
    case small, big
}
