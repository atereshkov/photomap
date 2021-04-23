//
//  AuthCoordinator.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/19/21.
//

import UIKit

class AuthCoordinator: Coordinator {
    
    private(set) var childCoordinators = [Coordinator]()
    private(set) var navigationController = UINavigationController()
    private var appCoordinator: AppCoordinator?
    
    init(appCoordinator: AppCoordinator) {
        self.appCoordinator = appCoordinator
    }

    @discardableResult
    func start() -> UIViewController {
       return UIViewController()
    }

    func openSignUpScreen() {
        
    }

    func showErrorAlert(error: ResponseError) {
        let alert = UIAlertController(title: error.title,
                                      message: error.message,
                                      preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: L10n.ok,
                                         style: .cancel) { [unowned self] _ in
            if case .networtConnection = error { self.navigationController.popViewController(animated: true) }
        }

        alert.addAction(cancelAction)
        self.navigationController.present(alert, animated: true)
    }

    func closeScreen() {
        navigationController.dismiss(animated: true, completion: nil)
        appCoordinator?.startMainScreen()
    }
    
}
