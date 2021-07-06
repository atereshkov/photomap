//
//  AppCoordinator.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/15/21.
//

import UIKit
import Combine

class AppCoordinator: AppCoordinatorType {
    
    private(set) var childCoordinators: [Coordinator] = []
    private(set) var navigationController = UINavigationController()
    private var diContainer: DIContainerType
    private let window: UIWindow
    
    private var cancelBag = CancelBag()
    
    init(window: UIWindow, diContainer: DIContainerType) {
        self.window = window
        self.diContainer = diContainer
    }
    
    func start() {
        window.rootViewController = navigationController
        self.showInitial()
    }
    
    func startMainScreen(isUserAuthorized: Bool) {
        if isUserAuthorized {
            self.showMap()
        } else {
            self.showAuth()
        }
    }
    
    internal func showMap() {
        let tabBarCoordinator = TabBarCoordinator(diContainer: diContainer)
        childCoordinators.append(tabBarCoordinator)
        let mainTabBarController = tabBarCoordinator.start()
        mainTabBarController.modalPresentationStyle = .overFullScreen
        navigationController.present(mainTabBarController, animated: true, completion: nil)
    }
    
    internal func showAuth() {
        let authCoordinator = AuthCoordinator(appCoordinator: self, diContainer: diContainer)
        childCoordinators.append(authCoordinator)
        let authViewController = authCoordinator.start()
        authViewController.modalPresentationStyle = .overFullScreen
        navigationController.present(authViewController, animated: true, completion: nil)
    }
    
    internal func showInitial() {
        let initCoordinator = InitialCoordinator(appCoordinator: self, diContainer: diContainer)
        childCoordinators = [initCoordinator]
        let initViewController = initCoordinator.start()
        initViewController.modalPresentationStyle = .overFullScreen
        navigationController.pushViewController(initViewController, animated: true)
    }
    
    func logout() {
        childCoordinators.removeAll()
        navigationController = UINavigationController()
        start()
    }
    
}
