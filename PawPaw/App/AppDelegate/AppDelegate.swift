//
//  AppDelegate.swift
//  PawPaw
//
//  Created by Eric Ziegler on 10/29/17.
//  Copyright © 2017 zigabytes. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Initialize PetFinderAPI to load access token
        let _ = PetFinderAPI.shared
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        if UserDefaults.standard.bool(forKey: HasInitializedLocationManagerCacheKey) && LocationManager.shared.isUsingCurrentLocation {
            LocationManager.shared.updateLocation()
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
    }


}

