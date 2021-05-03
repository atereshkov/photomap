//
//  InitialCoordinator.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 3.05.21.
//

import UIKit

class InitialCoordinator: Coordinator {
    
    private(set) var childCoordinators = [Coordinator]()
    private(set) var navigationController = UINavigationController()
    private var appCoordinator: AppCoordinator?
    
    init(appCoordinator: AppCoordinator) {
        self.appCoordinator = appCoordinator
    }
    
    @discardableResult
    func start() -> UIViewController {
        let initialVC = InitialViewController.newInstanse(with: appCoordinator!, diContainer: DIContainer())
        navigationController.pushViewController(initialVC, animated: true)
        
        return navigationController
    }
    
    func changeMainScreen(_ isUserAuth: Bool) {
        self.appCoordinator?.startMainScreen(isUserAuthorized: isUserAuth)
    }
    
}
