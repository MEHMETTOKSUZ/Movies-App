//
//  AppDelegate.swift
//  MoviesScroll
//
//  Created by Mehmet ÖKSÜZ on 20.12.2022.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Thread.sleep(forTimeInterval: 1.5)
        FirebaseApp.configure()
        
        RentMoviesTimer.shared.removeRentMoviesFromUserDefaults()
        
        if #available(iOS 13.0, *) {
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            if let windowScene = windowScene {
                let window = UIWindow(windowScene: windowScene)
                window.overrideUserInterfaceStyle = .light // Varsayılan olarak light moda geçiş yap
                self.window = window
                window.makeKeyAndVisible()
            }
        }
        
        
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        RentMoviesTimer.shared.removeRentMoviesFromUserDefaults()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        RentMoviesTimer.shared.removeRentMoviesFromUserDefaults()
        UserDefaults.standard.synchronize()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        RentMoviesTimer.shared.removeRentMoviesFromUserDefaults()
    }
    
    
    
    
    
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
    
    
}

