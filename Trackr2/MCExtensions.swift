//
//  MCExtensions.swift
//  Trackr2
//
//  Created by Matteo Comisso on 22/05/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import Foundation
import TMDBSwift

extension UserDefaults {

    func read<T: SerializableStruct>(structType: T.Type) -> Any? {

        switch structType {

        case is ConfigurationMDB.Type:

            if let object = self.object(forKey: String(describing: T.self)) as? StandardDict {
                return ConfigurationMDB.init(data: object)
            }
            return nil

        default:
            fatalError("Struct type not implemented")
        }
    }

    func save<T: SerializableStruct>(_ `struct`: T) throws {

        self.set(`struct`.asDictionary, forKey: String(describing: T.self))
        self.synchronize()
    }
}
