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
    private var authListener: AuthListenerType
    private var diContainer: DIContainerType
    private let window: UIWindow
    
    private var cancelBag = CancelBag()
    
    init(window: UIWindow, diContainer: DIContainerType) {
        self.window = window
        self.authListener = diContainer.resolve()
        self.diContainer = diContainer
        
        authListener.isUserAuthorized
            .sink { [weak self] isUserAuth in
                self?.startMainScreen(isUserAuthorized: isUserAuth)
            }
            .store(in: cancelBag)
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
        childCoordinators = [tabBarCoordinator]
        let mainTabBarController = tabBarCoordinator.start()
        mainTabBarController.modalPresentationStyle = .overFullScreen
        navigationController.present(mainTabBarController, animated: true, completion: nil)
    }
    
    internal func showAuth() {
        let authCoordinator = AuthCoordinator(appCoordinator: self, diContainer: diContainer)
        childCoordinators = [authCoordinator]
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
    
    func reset() {
        navigationController = UINavigationController()
        start()
    }
    
}
