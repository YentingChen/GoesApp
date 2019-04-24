//
//  AppDelegate.swift
//  Goes
//
//  Created by Yenting Chen on 2019/4/2.
//  Copyright © 2019年 yeinting. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Firebase
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
    -> Bool {
        // Override point for customization after application launch.
        GMSServices.provideAPIKey("AIzaSyBMCjRtdyWxo3BTOvl5B8ksVuCtqiONz4g")
        GMSPlacesClient.provideAPIKey("AIzaSyD_mMIHbDWkWE2p0c36ZjreWSIG1V4qmYE")
        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
            }

    func applicationDidEnterBackground(_ application: UIApplication) {
            }

    func applicationWillEnterForeground(_ application: UIApplication) {
       
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
      
    }

}
