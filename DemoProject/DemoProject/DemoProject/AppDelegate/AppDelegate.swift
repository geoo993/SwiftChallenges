//
//  AppDelegate.swift
//  DemoProject
//
//  Created by GEORGE QUENTIN on 11/05/2019.
//  Copyright © 2019 GEORGE QUENTIN. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var lastTime: CFTimeInterval = 0.0
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Places App
        // LocationManager.sharedManager.initializeLocationManager()
        
        
        // CatstagramApp
        //loadCatstagram()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        // For CatstagramApp
        //rootVC.sendLogs()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MEMENTO PATTERN: shouldSaveApplicationState and shouldRestoreApplicationState enables us to save are restore out app state
    func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    /*
     
    //// FOR CATSTAGRAM App
    func loadCatstagram() {
        window = WindowWithStatusBar(frame: UIScreen.main.bounds)
        let rootNavController = UINavigationController(rootViewController: CatFeedViewController())
        
        let font = UIFont(name: "OleoScript-Regular", size: 20.0)!
        rootNavController.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: font]
        rootNavController.navigationBar.barTintColor = UIColor.white
        rootNavController.navigationBar.isOpaque = true
        rootNavController.navigationItem.titleView?.isOpaque = true
        rootNavController.navigationBar.isTranslucent = false
        window?.rootViewController = rootNavController
        window?.makeKeyAndVisible()
 
         //let link = CADisplayLink(target: self, selector: #selector(AppDelegate.update(link:)))
         //link.add(to: RunLoop.main, forMode: RunLoop.Mode.common)
    }

    @objc func update(link: CADisplayLink) {
        //1
        if lastTime == 0.0 {
            lastTime = link.timestamp
        }
        
        //2
        let currentTime = link.timestamp
        let elapsedTime = floor((currentTime - lastTime) * 10_000)/10;
        
        //3
        if elapsedTime > 16.7 {
            print("Frame was dropped with elapsed time of \(elapsedTime) at \(currentTime)")
        }
        lastTime = link.timestamp
    }
    */
}

extension UINavigationController {
    open override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
}
