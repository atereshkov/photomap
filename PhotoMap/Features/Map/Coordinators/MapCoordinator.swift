//
//  MapCoordinator.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/19/21.
//

import UIKit

class MapCoordinator: Coordinator {
    private(set) var childCoordinators = [Coordinator]()
    private(set) var navigationController = UINavigationController()

    @discardableResult
    func start() -> UIViewController {
        let viewModel = MapViewModel(coordinator: self)
        let mapVC = MapViewController
                        .newInstanse(viewModel: viewModel)
        navigationController.pushViewController(mapVC, animated: true)

        return navigationController
    }
}
