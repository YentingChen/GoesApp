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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        GMSServices.provideAPIKey("AIzaSyBMCjRtdyWxo3BTOvl5B8ksVuCtqiONz4g")
        GMSPlacesClient.provideAPIKey("AIzaSyBMCjRtdyWxo3BTOvl5B8ksVuCtqiONz4g")
        FirebaseApp.configure()
//        Auth.auth().addStateDidChangeListener { [weak self] (_, user) in
//            
//            guard user != nil else {
//                
//                //Login
//                
//                let storyboard = UIStoryboard(name: "Auth", bundle: nil)
//                
//                self?.window?.rootViewController = storyboard.instantiateInitialViewController()
//                
//                return
//            }
//            
//            //Lobby
//            
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            
//            self?.window?.rootViewController = storyboard.instantiateInitialViewController()
//            
//        }

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
