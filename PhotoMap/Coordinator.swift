//
//  Coordinator.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/15/21.
//

import UIKit
import Combine

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get }
    var navigationController: UINavigationController { get }
    func childDidFinish(_ childCoordinator: Coordinator)
}

extension Coordinator {
    func generateErrorAlert(with error: GeneralErrorType) -> UIAlertController {
        let alert = UIAlertController(title: error.title,
                                      message: error.message,
                                      preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: L10n.ok, style: .cancel)
        alert.addAction(cancelAction)

        return alert
    }

    func showErrorAlert(error: GeneralErrorType) {
        let alert = UIAlertController(title: error.title,
                                      message: error.message,
                                      preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: L10n.ok, style: .cancel, handler: nil)

        alert.addAction(cancelAction)
        navigationController.present(alert, animated: true)
    }
    
    func childDidFinish(_ childCoordinator: Coordinator) {}
}
