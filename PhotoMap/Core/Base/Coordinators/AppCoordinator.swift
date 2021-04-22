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
    private var DIHelper: DIHelperType?
    
    init(DIHelper: DIHelperType) {
        self.authListener = DIHelper.resolve()
        self.DIHelper = DIHelper
    }

    func start() {
        navigationController.pushViewController(LoadingViewController.newInstanse(with: self, DIHelper: DIHelper),
                                                animated: true)
    }
    
    func changeMainScreen() {
        authListener?.isUserAuthorized { [weak self] isUserAuth in
            if isUserAuth {
                self?.showMap()
            } else {
                self?.showAuth()
            }
        }
    }
    
    private func showMap() {
        let tabBarCoordinator = TabBarCoordinator(DIHelper: DIHelper)
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
