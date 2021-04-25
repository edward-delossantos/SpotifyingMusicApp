//
//  AppDelegate.swift
//  SpotifyingMusicApp
//
//  Created by Edward de los Santos on 4/17/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let welcomeViewController: WelcomeViewController = mainStoryboard.instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
        
        let loginViewController: LoginViewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        
        if AuthManager.shared.isSignedIn{
           AuthManager.shared.refreshIfNeeded(completion: nil)
            self.window?.rootViewController = welcomeViewController
        } else {
            self.window?.rootViewController = loginViewController
        }
        
        self.window?.makeKeyAndVisible()
        return true
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

