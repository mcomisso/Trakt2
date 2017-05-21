//
//  MCDataLayer.swift
//  Trackr2
//
//  Created by Matteo Comisso on 19/05/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift


typealias MovieCompletion = (Bool, [Movie]) -> Void
typealias Completion = (Bool, Any?) -> Void



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

    // Networking requests
    fileprivate let traktAPI = MCTraktAPI()

    fileprivate var tmdbConfiguration: TMDBConfiguration?

    fileprivate var movies = [Movie]()

    // MARK: Initializers

    init() { }


    // Read from documents directory

    fileprivate func read<T: SerializableStruct>(structType: T.Type) {

        let readingPath = self.documentFolder.appendingPathComponent(String(describing: T.self))


        switch structType {

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

    func listMovies(completion: @escaping MovieCompletion)  {

        var realm: Realm?

        do {
            realm = try Realm()
        } catch {
            print(error)
            completion(false, self.movies)
        }

        if self.movies.isEmpty {
            // Network request

            self.traktAPI.request(endpoint: MCTrackrEndpoint.trendingMovies()).response { resp in

                if let error = resp.error {
                    print(error.localizedDescription)
                    completion(false, [])
                } else {
                    if let data = resp.data {
                        let json = JSON(data: data)
                        for (index, movieJSON) in json.arrayValue.enumerated() {
                            let movie = try! Movie(json: movieJSON)
                            movie.trendingIndex = index
                            try! realm?.write {
                                realm?.add(movie, update: true)
                            }
                        }

                        guard let objects = realm?.objects(Movie.self) else { completion(false, []); return }
                        completion(true, Array(objects))
                    }
                }
            }

        } else {
            completion(true, self.movies)
        }
    }


    public func readTMDBConfiguration(completion: @escaping Completion) {
        let tmdbAPI = MCtmdbAPI()

        if let conf = self.tmdbConfiguration {
            completion(true, conf)
        } else {
            tmdbAPI.request(endpoint: tmdbEndpoints.configuration()).response { [weak self] (resp) in
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

