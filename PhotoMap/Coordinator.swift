//
//  Coordinator.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/15/21.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get }
    var navigationController: UINavigationController { get }
}

extension Coordinator {
    func generateErrorAlert(with error: GeneralErrorType) -> UIAlertController {
        let alert = UIAlertController(title: error.title,
                                      message: error.message,
                                      preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "OK".localized, style: .cancel)
        alert.addAction(cancelAction)

        return alert
    }
}
