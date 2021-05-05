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
    private var diContainer: DIContainerType
    
    init(appCoordinator: AppCoordinator, diContainer: DIContainerType) {
        self.appCoordinator = appCoordinator
        self.diContainer = diContainer
    }
    
    @discardableResult
    func start() -> UIViewController {
        let viewModel = InitialViewModel(coordinator: self, diContainer: diContainer)
        let initialVC = InitialViewController.newInstanse(viewModel: viewModel)
        
        return initialVC
    }
    
    func changeMainScreen(_ isUserAuth: Bool) {
        self.appCoordinator?.startMainScreen(isUserAuthorized: isUserAuth)
    }
    
}
