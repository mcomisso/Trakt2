//
//  MCTMDBAPI.swift
//  Trackr2
//
//  Created by Matteo Comisso on 19/05/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import Foundation
import Alamofire


final class MCTMDBAPI: MCAPI {

    // MARK: Endpoints

    enum TMDBEndpoints: Endpoint {

        static let baseURL = MCConstants.baseURLs.tmdb

        case configuration// = "/configuration"
        case movie(id: Int)// = "/movie/34576"
        case movieImage(id: Int) // = "/movie/34576/images"

        var isReachable: Bool {
            get {
                return NetworkReachabilityManager(host: TMDBEndpoints.baseURL)?.isReachable ?? false
            }
        }

        var path: String {
            switch self {
            case .configuration:
                return "/configuration"
            case .movie(let id):
                return "/movie/\(id)"
            case .movieImage(let id):
                return "/movie/\(id)/images"
            }
        }

        func asURLRequest() throws -> URLRequest {
            let baseURL = try TMDBEndpoints.baseURL.asURL()
            return URLRequest(url: baseURL.appendingPathComponent(path))
        }
    }

    // MARK: Private Vars

    private let apiKey = MCConstants.TMDBAPI.apiKey
    
    var sessionManager: SessionManager {
        get {
            return Alamofire.SessionManager.default
        }
    }

    func request(endpoint: Endpoint) -> DataRequest {
        let defaultParameters: Parameters = ["api_key": self.apiKey]

        var urlReq = try! endpoint.asURLRequest()
        urlReq = try! URLEncoding.default.encode(urlReq, with: defaultParameters)

        if endpoint.isReachable {
            urlReq.cachePolicy = .reloadIgnoringLocalCacheData
        } else {
            urlReq.cachePolicy = .returnCacheDataDontLoad
        }

        return self.sessionManager.request(urlReq)
    }

}

extension MCTMDBAPI {

    func fetchImageForMovie(movie: Movie) -> DataRequest {
        return self.request(endpoint: TMDBEndpoints.movie(id: movie.tmdb))
    }

    func fetchConfiguration() -> DataRequest {
        return self.request(endpoint: TMDBEndpoints.configuration)
    }
}
