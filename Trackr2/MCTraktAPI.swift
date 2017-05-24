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
        }
    }

    static let baseURL = MCConstants.baseURLs.production

    func asURLRequest() throws -> URLRequest {
        let requestURL = try MCTrackrEndpoint.baseURL.asURL().appendingPathComponent(path)

        var urlcomponents = URLComponents(string: requestURL.absoluteString)
        urlcomponents?.queryItems = [URLQueryItem(name: "limit", value: "100")]


        guard let url = try! urlcomponents?.asURL() else { fatalError() }
        return URLRequest(url: url)
    }
}

final class MCTraktAPI: MCAPI {

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

    func request(endpoint: URLRequestConvertible) -> DataRequest {
        let urlReq = try! endpoint.asURLRequest()

        return self.sessionManager.request(urlReq)
    }

}
