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
    private(set) var navigationController = UINavigationController()

    private var cancelBag = CancelBag()
    private let diContainer: DIContainerType
    private(set) var dismissSubject = PassthroughSubject<UIControl, Never>()

    init(diContainer: DIContainerType) {
        self.diContainer = diContainer

        bind()
    }

    func start( photo: Photo) -> UINavigationController {
        let viewModel = MapPhotoViewModel(coordinator: self, diContainer: DIContainer(), photo: photo)
        let vc = MapPhotoViewController.newInstanse(viewModel: viewModel)
        navigationController.pushViewController(vc, animated: true)

        return navigationController
    }

    private func bind() {
        dismissSubject
            .sink { [weak self] _ in
                self?.navigationController.dismiss(animated: true)
            }
            .store(in: cancelBag)
    }
}
