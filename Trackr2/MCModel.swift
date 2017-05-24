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

    var asDictionary: StandardDict {
        get {
            return [
                "baseUrl": self.baseUrl
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

