//
//  MCDataLayer.swift
//  Trackr2
//
//  Created by Matteo Comisso on 19/05/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import Foundation
import SwiftyJSON


typealias MovieCompletion = (Bool, [Movie]) -> Void
typealias Completion = (Bool, Any?) -> Void

enum SerializableError: Error {
    case saveFile
}


final class MCDataLayer {

    // MARK: Private variables
    private let documentFolder: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

    fileprivate var moviesIndex: [Int] = []

    fileprivate var movies: [Movie] = []

    fileprivate let networkLayer = MCNetworkLayer()

    // MARK: Initializers

    init() { }

}

extension MCDataLayer {


    func listDetailsForMovie(movie: Movie, completion: (Bool, TMDBMovie)->Void) {

    }

    func listMovies(completion: @escaping MovieCompletion)  {

        if self.movies.isEmpty {
            // Network request

            self.traktAPI.request(endpoint: MCTrackrEndpoint.trendingMovies()).response { [weak self] resp in
                guard let strongSelf = self else { return }

                if let error = resp.error {
                    print(error.localizedDescription)
                    completion(false, [])
                } else {
                    if let data = resp.data {
                        let json = JSON(data: data)
                        for movieJSON in json.arrayValue {
                            let movie = try! Movie(json: movieJSON)
                            strongSelf.movies.append(movie)
                        }

                        completion(true, strongSelf.movies)
                        try! strongSelf.save(strongSelf.movies)
                    }
                }
            }

        } else {
            completion(true, self.movies)
        }
    }


    public func readTMDBConfiguration(completion: @escaping Completion) {

        if let conf = self.tmdbConfiguration {
            completion(true, conf)
        } else {
            MCtmdbAPI().request(endpoint: tmdbEndpoints.configuration()).response { [weak self] (resp) in
                guard let strongSelf = self else { return }

                if let error = resp.error {
                    print(error.localizedDescription)
                    completion(false, nil)
                } else if let data = resp.data {
                    let conf = TMDBConfiguration(data: data)

                    try! strongSelf.save(conf)
                    strongSelf.tmdbConfiguration = conf
                    completion(true, conf)
                }
            }
        }
    }

}
