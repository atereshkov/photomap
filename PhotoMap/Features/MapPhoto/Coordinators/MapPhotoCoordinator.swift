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

    weak var parentCoordinator: Coordinator?
    
    private var cancelBag = CancelBag()
    private let diContainer: DIContainerType
    private(set) var dismissSubject = PassthroughSubject<UIControl, Never>()
    private(set) var errorAlertSubject = PassthroughSubject<FirestoreError, Never>()

    init(diContainer: DIContainerType) {
        self.diContainer = diContainer

        bind()
    }

    func start(with photo: Photo) -> UINavigationController {
        let viewModel = MapPhotoViewModel(coordinator: self, diContainer: diContainer, photo: photo)
        let vc = MapPhotoViewController.newInstanse(viewModel: viewModel)
        navigationController.pushViewController(vc, animated: true)

        return navigationController
    }

    private func bind() {
        dismissSubject
            .sink { [weak self] _ in
                self?.dismissScreen()
            }
            .store(in: cancelBag)
        
        errorAlertSubject
            .sink(receiveValue: { [weak self] error in self?.showErrorAlert(error: error) })
            .store(in: cancelBag)
    }
    
    private func dismissScreen() {
        navigationController.dismiss(animated: true)
        parentCoordinator?.childDidFinish(self)
    }
}
