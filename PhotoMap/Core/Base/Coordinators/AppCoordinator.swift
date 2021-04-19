//
//  AppCoordinator.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/15/21.
//

import UIKit
import Firebase

class AppCoordinator: Coordinator {
    static let shared = AppCoordinator()

    private(set) var childCoordinators: [Coordinator] = []
    private(set) var navigationController = UINavigationController()

    private init() { }

    func start() {
        navigationController.pushViewController(LoadingViewController.newInstanse(with: self),
                                                animated: true)
    }
    
    func changeMainScreen() {
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            if user != nil {
                guard self != nil else { return }
                self?.showMap()
            } else {
                self?.showAuth()
            }
        }
    }
    
    private func showMap() {
        let tabBarCoordinator = TabBarCoordinator()
        childCoordinators = [tabBarCoordinator]
        let mainTabBarController = tabBarCoordinator.start()
        mainTabBarController.modalPresentationStyle = .overFullScreen
        navigationController.present(mainTabBarController, animated: true, completion: nil)
    }

    private func showAuth() {
        let authCoordinator = AuthCoordinator()
        childCoordinators = [authCoordinator]
        let authViewController = authCoordinator.start()
        authViewController.modalPresentationStyle = .overFullScreen
        navigationController.present(authViewController, animated: true, completion: nil)
    }
}
