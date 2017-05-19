//
//  MCtmdbAPI.swift
//  Trackr2
//
//  Created by Matteo Comisso on 19/05/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import Foundation
import Alamofire

fileprivate enum tmdbEndpoints: URLRequestConvertible {

    static let baseURL = "https://api.themoviedb.org/3"

    case configuration()// = "/configuration"
    case movie()// = "/movie"

    var path: String {
        switch self {
        case .configuration:
            return "/configuration"
        case .movie:
            return "/movie"
        }
    }

    func asURLRequest() throws -> URLRequest {
        let baseURL = try tmdbEndpoints.baseURL.asURL()
        return URLRequest(url: baseURL.appendingPathComponent(path))
    }
}

final class MCtmdbAPI: MCAPI {

    private let apiKey = "".c._8._8.f._5.d.e.c.b.e._1.d._6._4.c.c._2._7._6._8._5.a.c._5._0._9._0._4._4._3._7._6

    var sessionManager: SessionManager {
        get {
            return Alamofire.SessionManager.default
        }
    }

    func request(endpoint: URLRequestConvertible) -> DataRequest {
        return self.sessionManager.request(endpoint)
    }
}
