//
//  MCSerializableStruct.swift
//  Trackr2
//
//  Created by Matteo Comisso on 23/05/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import Foundation

typealias StandardDict = [String: Any]

protocol SerializableStruct {
    var asDictionary: StandardDict { get }
    init?(data: StandardDict)
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

        guard let structValue = T(data: data) else { return nil }
        self.structValue = structValue
    }
}
