//
//  AppCoordinator.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/15/21.
//

import UIKit

class AppCoordinator: Coordinator {
    
    private(set) var childCoordinators: [Coordinator] = []
    private(set) var navigationController = UINavigationController()
    private var authListener: AuthListenerType?
    private var diContainer: DIContainerType?
    
    init(diContainer: DIContainerType) {
        self.authListener = diContainer.resolve()
        self.diContainer = diContainer
    }

    func start() {
        authListener?.startListening()
    }
    
    private func showMap() {
        let tabBarCoordinator = TabBarCoordinator(diContainer: diContainer)
        childCoordinators = [tabBarCoordinator]
        let mainTabBarController = tabBarCoordinator.start()
        mainTabBarController.modalPresentationStyle = .overFullScreen
        navigationController.present(mainTabBarController, animated: true, completion: nil)
    }

    private func showAuth() {
        let authCoordinator = AuthCoordinator(appCoordinator: self)
        childCoordinators = [authCoordinator]
        let authViewController = authCoordinator.start()
        authViewController.modalPresentationStyle = .overFullScreen
        navigationController.present(authViewController, animated: true, completion: nil)
    }
    
}
