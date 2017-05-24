//
//  MCConstants.swift
//  Trackr2
//
//  Created by Matteo Comisso on 19/05/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import Foundation

struct MCConstants {
    struct TraktAPI {
        // Strings are obfuscated with UAObfuscatedString. Static analysis of binary is harder.

        // Client ID
        // 0e7e55d561c7e688868a5ea7d2c82b17e59fde95fbc2437e809b1449850d4162
        static let clientID = ""._0.e._7.e._5._5.d._5._6._1.c._7.e._6._8._8._8._6._8.a._5.e.a._7.d._2.c._8._2.b._1._7.e._5._9.f.d.e._9._5.f.b.c._2._4._3._7.e._8._0._9.b._1._4._4._9._8._5._0.d._4._1._6._2

        // Client Secret
        // acac2f8984eff126f39d2aa53ce08366733fda1013cc6e5e09699dadbbab517f
        static let clientSecret = "".a.c.a.c._2.f._8._9._8._4.e.f.f._1._2._6.f._3._9.d._2.a.a._5._3.c.e._0._8._3._6._6._7._3._3.f.d.a._1._0._1._3.c.c._6.e._5.e._0._9._6._9._9.d.a.d.b.b.a.b._5._1._7.f
    }

    struct TMDBAPI {
        static let apiKey = "".c._8._8.f._5.d.e.c.b.e._1.d._6._4.c.c._2._7._6._8._5.a.c._5._0._9._0._4._4._3._7._6
    }

    struct baseURLs {
        static let staging = stringForKey("baseURL-staging", plist: "Trackt")
        static let production = stringForKey("baseURL-production", plist: "Trackt")

        static let tmdb = stringForKey("tmdbURL", plist: "Trackt")
    }

}

// Loader
fileprivate func stringForKey(_ key: String, plist: String) -> String {

    guard let plistFilePath = Bundle.main.path(forResource: plist, ofType: "plist"),
        let dictionary = NSDictionary(contentsOfFile: plistFilePath) as? [String: AnyObject],
        let value = dictionary[key] as? String else { fatalError("Errors while reading plist file \(plist)") }
    
    return value
}
