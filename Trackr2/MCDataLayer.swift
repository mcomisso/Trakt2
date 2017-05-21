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


        case is TMDBConfiguration.Type:

            guard let objects = NSKeyedUnarchiver.unarchiveObject(withFile: readingPath.path) as? [MCStructSerializer<TMDBConfiguration>],
                let configuration = objects.first else { fatalError() }

            self.tmdbConfiguration = configuration.structValue


        default:
            fatalError("Struct not implemented")
        }
    }


    // Write to documents directory

    private func save<T: SerializableStruct>(structs: [T]) throws {

        let savePath = self.documentFolder.appendingPathComponent(String(describing: T.self))

        let archiveData = structs.map{ $0.asDictionary }
        if !NSKeyedArchiver.archiveRootObject(archiveData, toFile: savePath.path ) {
            throw SerializableError.saveFile
        }
    }


    func listMovies() -> [Movie] {
        return self.movies
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
