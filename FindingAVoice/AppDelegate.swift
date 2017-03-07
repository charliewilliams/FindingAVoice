//
//  AppDelegate.swift
//  ControlTask
//
//  Created by Charlie Williams on 05/01/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        Fabric.with([Crashlytics.self, Answers.self])
        FIRApp.configure()
        
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
            
            // TODO analytics for relaunch after time is up
            window?.rootViewController?.present(TimesUpLockViewController(), animated: false, completion: nil)
        }
    }
}

