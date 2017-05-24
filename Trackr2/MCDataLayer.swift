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

    /// Requests the movies to
    ///
    /// - Parameter completion: Completion with movies
    func listMovies(completion: @escaping MovieCompletion) {

        if self.movies.isEmpty {
            self.networkLayer.fetchMovies { (success, data: Any?) in
                if success {
                    guard let movies = data as? [Movie] else { return }
                    self.movies = movies
                    completion(true, movies)
                } else {
                    completion(false, [])
                }
            }
        } else {
            completion(true, movies)
        }
    }
}
