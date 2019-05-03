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
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate{

    var window: UIWindow?
    var manager = CLLocationManager()

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
    -> Bool {
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            // For iOS 10 data message (sent via FCM
            Messaging.messaging().delegate = self
           
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
            
        }
        application.registerForRemoteNotifications()
        
        
        // Override point for customization after application launch.
        GMSServices.provideAPIKey("AIzaSyBMCjRtdyWxo3BTOvl5B8ksVuCtqiONz4g")
        GMSPlacesClient.provideAPIKey("AIzaSyD_mMIHbDWkWE2p0c36ZjreWSIG1V4qmYE")
        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true
//        let pushManager = PushNotificationManager(userID: "currently_logged_in_user_id")
//        pushManager.registerForPushNotifications()
        
       
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
            }

    func applicationDidEnterBackground(_ application: UIApplication) {
        application.setMinimumBackgroundFetchInterval(UIApplication.backgroundFetchIntervalMinimum)
            }

    func applicationWillEnterForeground(_ application: UIApplication) {
       
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
      
    }
    
    func applicationReceivedRemoteMessage(_ remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage.appData)
    }
    
    
}
