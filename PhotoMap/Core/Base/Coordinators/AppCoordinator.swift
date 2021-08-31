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
    private let authListener: AuthListenerType
    private var diContainer: DIContainerType
    private let window: UIWindow
    
//    private var subscriptions = Set<AnyCancellable>()
    private var tabBarCoordinatorSubscription: AnyCancellable?
    private var authCoordinatorSubscription: AnyCancellable?
    
    init(window: UIWindow, diContainer: DIContainerType) {
        self.window = window
        self.diContainer = diContainer
        self.authListener = diContainer.resolve()
    }
    
    func start() {
        navigationController.view.backgroundColor = .darkGray
        let initialVC = InitialViewController.newInstanse()
        navigationController.pushViewController(initialVC, animated: true)
        
        window.rootViewController = navigationController
        changeApplicationState()
    }

    private func changeApplicationState() {
        if authListener.isAuthorized() {
            authCoordinatorSubscription?.cancel()
            authCoordinatorSubscription = nil

            showMap()
        } else {
            tabBarCoordinatorSubscription?.cancel()
            tabBarCoordinatorSubscription = nil

            showAuth()
        }
    }
    
    private func showMap() {
        let tabBarCoordinator = TabBarCoordinator(diContainer: diContainer)
        tabBarCoordinatorSubscription = tabBarCoordinator.dismissSubject
            .sink(receiveValue: { [weak self] in self?.prepareForSwitchAppStatus() })

        childCoordinators.append(tabBarCoordinator)
        navigationController.present(tabBarCoordinator.start(), animated: true)
    }
    
    private func showAuth() {
        let signInCoordinator = AuthCoordinator(diContainer: diContainer)
        authCoordinatorSubscription = signInCoordinator.dismissSubject
            .sink(receiveValue: { [weak self] in self?.prepareForSwitchAppStatus() })

        childCoordinators.append(signInCoordinator)
        navigationController.present(signInCoordinator.start(), animated: true)
    }
    
    private func prepareForSwitchAppStatus() {
        childCoordinators = []
        changeApplicationState()
    }
}
