//
//  SceneDelegate.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/15/21.
//

import UIKit
import Firebase

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        FirebaseApp.configure()
        
        let diContainer = DIContainer()
        let appCoordinator = AppCoordinator(diContainer: diContainer)
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = appCoordinator.navigationController
        self.window = window
        window.makeKeyAndVisible()
      
        appCoordinator.start()
    }
}
