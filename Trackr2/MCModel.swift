//
//  MCModel.swift
//  Trackr2
//
//  Created by Matteo Comisso on 19/05/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import Foundation
import SwiftyJSON


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
}

