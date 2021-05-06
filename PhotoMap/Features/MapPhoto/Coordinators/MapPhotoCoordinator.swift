//
//  MapPhotoCoordinator.swift
//  PhotoMap
//
//  Created by Dzmitry Makarevich on 6.05.21.
//

import MapKit

class MapPhotoCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController

    init() {
        navigationController = UINavigationController()
    }

    func start() -> MapPhotoViewController {
        let viewModel = MapPhotoViewModel()
        let vc = MapPhotoViewController.newInstanse(viewModel: viewModel)
        navigationController.present(vc, animated: true)

        return vc
    }
}
