//
//  MapPhotoCoordinator.swift
//  PhotoMap
//
//  Created by Dzmitry Makarevich on 6.05.21.
//

import UIKit
import Combine

class MapPhotoCoordinator: Coordinator {
    private(set) var childCoordinators: [Coordinator] = []
    private(set) var navigationController: UINavigationController

    private var cancelBag = CancelBag()
    @Published var dismissPublisher: Void?

    init() {
        navigationController = UINavigationController()

        bind()
    }

    func start() -> UINavigationController {
        let viewModel = MapPhotoViewModel(coordinator: self,
                                          diContainer: DIContainer())
        let vc = MapPhotoViewController.newInstanse(viewModel: viewModel)
        navigationController.pushViewController(vc, animated: true)

        return navigationController
    }

    private func bind() {
        $dismissPublisher
            .filter { $0 != nil }
            .sink { [weak self] _ in
                self?.navigationController.dismiss(animated: true)
            }
            .store(in: cancelBag)
    }
}
