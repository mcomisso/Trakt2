//
//  AppDelegate.swift
//  Trackr2
//
//  Created by Matteo Comisso on 18/05/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        MCNetworkLayer.fetchTMDBConfiguration()

        return true
    }

}

