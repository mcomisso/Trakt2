//
//  MCDataLayer.swift
//  Trackr2
//
//  Created by Matteo Comisso on 19/05/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import Foundation

typealias StandardDict = [String: Any]

enum SerializableError: Error {
    case saveFile
}

protocol SerializableStruct {
    var asDictionary: StandardDict { get }
    init(data: StandardDict)
}


/// This class serializes structs to allow NSCoding saving in plist files.
final class MCStructSerializer<T: SerializableStruct>: NSObject, NSCoding {

    var structValue: T

    init(structValue: T) {
        self.structValue = structValue
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.structValue.asDictionary, forKey: String(describing: T.self))
    }

    required init?(coder aDecoder: NSCoder) {
        let data = aDecoder.decodeObject(forKey: String(describing: T.self)) as! StandardDict
        self.structValue = T(data: data)
    }
}


final class MCDataLayer {

    // MARK: Private variables
    private let documentFolder: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

    fileprivate var movies: [Movie] = []
    fileprivate var tmdbConfiguration: TMDBConfiguration?

    fileprivate let traktAPI = MCTraktAPI()

    // MARK: Initializers

    init() {
        self.read(structType: Movie.self)
        self.read(structType: TMDBConfiguration.self)
    }


    // Read from documents directory

    fileprivate func read<T: SerializableStruct>(structType: T.Type) {

        let readingPath = self.documentFolder.appendingPathComponent(String(describing: T.self))


        switch structType {

        case is Movie.Type:
            guard let objects = NSKeyedUnarchiver.unarchiveObject(withFile: readingPath.path) as? [MCStructSerializer<Movie>] else { fatalError() }

            self.movies = objects.map{ $0.structValue }

        case is Movie.Type:
            if let objects = NSKeyedUnarchiver.unarchiveObject(withFile: readingPath.path) as? [MCStructSerializer<Movie>] {
                self.movies = objects.map{ $0.structValue }
            }

        case is TMDBConfiguration.Type:

            if let objects = NSKeyedUnarchiver.unarchiveObject(withFile: readingPath.path) as? [MCStructSerializer<TMDBConfiguration>],
                let configuration = objects.first {

                self.tmdbConfiguration = configuration.structValue
            }

        default:
            fatalError("Struct type not implemented")
        }
    }


    // Write to documents directory

    fileprivate func save<T: SerializableStruct>(_ `struct`: T) throws {

        let savePath = self.documentFolder.appendingPathComponent(String(describing: T.self))

        let archiveData = `struct`.asDictionary
        if !NSKeyedArchiver.archiveRootObject(archiveData, toFile: savePath.path ) {
            throw SerializableError.saveFile
        }
    }


    fileprivate func save<T: SerializableStruct>(_ structs: [T]) throws {

        let savePath = self.documentFolder.appendingPathComponent(String(describing: T.self))

        let archiveData = structs.map{ $0.asDictionary }
        if !NSKeyedArchiver.archiveRootObject(archiveData, toFile: savePath.path ) {
            throw SerializableError.saveFile
        }
    }
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
