//
//  MCNetworkLayer.swift
//  Trackr2
//
//  Created by Matteo Comisso on 22/05/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import Foundation
import SwiftyJSON
import TMDBSwift

enum MCNetworkError: Error {
    case noConnection(message: String, code: Int)
}

final class MCNetworkLayer {

    let traktAPI = MCTraktAPI()

    static func fetchDetailsForMovie(movie: Movie, completion: @escaping Completion) {

        MovieMDB.movie(MCConstants.TMDBAPI.apiKey, movieID: movie.tmdb) { (clientReturn, detailedMovie) in

            if let error = clientReturn.error {
                completion(false, error.localizedDescription)
            } else if let detailedMovie = detailedMovie {
                completion(true, detailedMovie)
            }
        }

    }

    static func fetchImageForMovie(movie: Movie, dimension: TMDBImageDimension, completion: @escaping Completion) {

        MovieMDB.images(MCConstants.TMDBAPI.apiKey, movieID: movie.tmdb) { (clientReturn, images) in
            if let posters = images?.posters,
                let conf = UserDefaults.standard.read(structType: ConfigurationMDB.self) as? ConfigurationMDB,
                let path = posters.first?.file_path {

                let url = conf.generatePosterUrl(secure: true, dimension: dimension).appendingPathComponent(path)
                completion(true, url)
            } else {
                completion(false, nil)
            }
        }
    }

    static func fetchTMDBConfiguration() {
        ConfigurationMDB.configuration(MCConstants.TMDBAPI.apiKey) { (clientReturn, configuration) in
            if let configuration = configuration {
                do {
                    try UserDefaults.standard.save(configuration)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }

    func fetchMovies(completion: @escaping Completion) {

        var movies = [Movie]()

        self.traktAPI.fetchTrendingMovies().response { resp in

            if let error = resp.error {
                completion(false, error.localizedDescription)
            } else {
                if let data = resp.data {
                    let json = SwiftyJSON.JSON(data: data)
                    for movieJSON in json.arrayValue {
                        do {
                            let movie = try Movie(json: movieJSON)
                            movies.append(movie)
                        } catch {
                            completion(false, error.localizedDescription)
                            return
                        }
                    }

                    completion(true, movies)
                }
            }
        }
    }

}
