//
//  SceneDelegate.swift
//  NIBM Events
//
//  Created by Pradeep Sanjaya on 2/26/20.
//  Copyright © 2020 Pradeep Sanjaya. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var userService = UserService()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        // login
        /*
        let storyboard : UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let mainNavigationController = storyboard.instantiateViewController(withIdentifier: "MainNavigationController") as? MainNavigationController
        self.window = self.window ?? UIWindow()
        self.window!.rootViewController = mainNavigationController
        */
        
        // main
        var isUserLogedIn = false
        if let user:User = userService.getLocalUser() {
            if (user.token != "") {
                isUserLogedIn = true
            }
        }

        if (isUserLogedIn) {
            /*
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let mainTabBarController = storyboard.instantiateViewController(withIdentifier: "MainTabBar") as? MainTabBarController
            UIApplication.shared.windows.first?.rootViewController = mainTabBarController
            */
            
            let storyboardMain : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let mainTabBarController = storyboardMain.instantiateViewController(withIdentifier: "MainTabBar") as? MainTabBarController
            
            let storyboardLogin : UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
            let touchIdViewController = storyboardLogin.instantiateViewController(withIdentifier: "TouchIdViewController") as? TouchIdViewController
            touchIdViewController?.nextViewController = mainTabBarController
                
            UIApplication.shared.windows.first?.rootViewController = touchIdViewController
            
        } else {
            let storyboard : UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
            let mainNavigationController = storyboard.instantiateViewController(withIdentifier: "MainNavigationController") as? MainNavigationController
            UIApplication.shared.windows.first?.rootViewController = mainNavigationController
        }
        
        UIApplication.shared.windows.first?.makeKeyAndVisible()
        
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

