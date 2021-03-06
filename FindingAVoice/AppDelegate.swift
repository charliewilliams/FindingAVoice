//
//  AppDelegate.swift
//  ControlTask
//
//  Created by Charlie Williams on 05/01/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseDatabase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        UserHandler.instance.handleSessionStart()
        DailyTimer.shared.resume()
        checkDailyTimeExceeded()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
        DailyTimer.shared.pause()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
        DailyTimer.shared.pause()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {

        DailyTimer.shared.resume()
        checkDailyTimeExceeded()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {

        DailyTimer.shared.resume()
        checkDailyTimeExceeded()
    }
}

private extension AppDelegate {
    
    func checkDailyTimeExceeded() {
        
        if DailyTimer.shared.hasPlayedMaxTimeToday {
            
            Analytics.userRelaunchedAfterTimeUp()
            
            window?.rootViewController?.present(EndOfDayCelebrateViewController(), animated: false, completion: nil)
        }
    }
}

