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

    static let baseURL = ""

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

    var sessionManager: SessionManager {
        get {
            return Alamofire.SessionManager.default
        }
    }

    func request(endpoint: URLRequestConvertible) -> DataRequest {
        return self.sessionManager.request(endpoint)
    }
}
