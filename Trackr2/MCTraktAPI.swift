//
//  MCTrackrAPI.swift
//  Trackr2
//
//  Created by Matteo Comisso on 19/05/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import Foundation
import Alamofire

final class MCTraktAPI: MCAPI {

    // Endpoints

    enum MCTracktEndpoint: Endpoint {

        static let baseURL = MCConstants.baseURLs.production

        // Enumeration of cases
        case trendingMovies

        private var path: String {
            switch self {
            case .trendingMovies:
                return "/movies/trending"
            }
        }

        var isReachable: Bool {
            get {
                return NetworkReachabilityManager(host: MCTracktEndpoint.baseURL)?.isReachable ?? false
            }
        }

        func asURLRequest() throws -> URLRequest {
            let requestURL = try MCTracktEndpoint.baseURL.asURL().appendingPathComponent(path)

            var urlcomponents = URLComponents(string: requestURL.absoluteString)
            urlcomponents?.queryItems = [URLQueryItem(name: "limit", value: "100")]

            guard let url = try! urlcomponents?.asURL() else { fatalError() }
            return URLRequest(url: url)
        }
    }


    let sessionManager: SessionManager

    public init() {
        var defaultHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        defaultHeaders["trakt-api-version"] = "2"
        defaultHeaders["trakt-api-key"] = MCConstants.TraktAPI.clientID
        defaultHeaders["Content-type"] = "application/json"

        let conf = URLSessionConfiguration.default
        conf.httpAdditionalHeaders = defaultHeaders
        self.sessionManager = Alamofire.SessionManager(configuration: conf)
    }

    func request(endpoint: Endpoint) -> DataRequest {
        var urlReq = try! endpoint.asURLRequest()

        if endpoint.isReachable {
            urlReq.cachePolicy = .reloadIgnoringLocalCacheData
        } else {
            urlReq.cachePolicy = .returnCacheDataDontLoad
        }

        return self.sessionManager.request(urlReq)
    }
}

// Wrappers
extension MCTraktAPI {
    func fetchTrendingMovies() -> DataRequest {
        return self.request(endpoint: MCTracktEndpoint.trendingMovies)
    }
}
