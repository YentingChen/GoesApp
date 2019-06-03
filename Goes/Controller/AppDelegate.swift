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
import UserNotifications
import IQKeyboardManagerSwift
import FirebaseInstanceID
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{

    var window: UIWindow?
    
    var manager = CLLocationManager()

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
        print("applicationWillResignActive")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
//        application.setMinimumBackgroundFetchInterval(UIApplication.backgroundFetchIntervalMinimum)
        print("applicationDidEnterBackground")
            }

    func applicationWillEnterForeground(_ application: UIApplication) {
       print("applicationWillEnterForeground")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        print("applicationDidBecomeActive")
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
      print("applicationWillTerminate")
    }
    
    func applicationReceivedRemoteMessage(_ remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage.appData)
    }
    
}
