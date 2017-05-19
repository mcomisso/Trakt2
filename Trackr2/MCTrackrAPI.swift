//
//  MCTrackrAPI.swift
//  Trackr2
//
//  Created by Matteo Comisso on 19/05/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import Foundation
import Alamofire

enum MCTrackrEndpoint: URLRequestConvertible {

    // Enumeration of cases
    case trendingMovies()

    private var path: String {
        switch self {
        case .trendingMovies:
            return "/movies/trending"
//        default:
//            fatalError()
        }
    }

    static let baseURL = MCConstants.baseURLs.production

    func asURLRequest() throws -> URLRequest {
        let url = try MCTrackrEndpoint.baseURL.asURL()

        let urlRequest = URLRequest(url: url.appendingPathComponent(path))
        return urlRequest
    }
}

final class MCTrackrAPI: MCAPI {

    var sessionManager: SessionManager {
        get {
            var defaultHeaders = Alamofire.SessionManager.defaultHTTPHeaders
            defaultHeaders["trakt-api-version"] = "2"
            defaultHeaders["trakt-api-key"] = MCConstants.API.clientID
            defaultHeaders["Content-type"] = "application/json"

            let conf = URLSessionConfiguration.default
            conf.httpAdditionalHeaders = defaultHeaders
            return Alamofire.SessionManager(configuration: conf)
        }
    }

    public init() { }

    func request(endpoint: URLRequestConvertible) -> DataRequest {
        return self.sessionManager.request(endpoint)
    }

}
