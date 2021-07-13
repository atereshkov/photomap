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

    private(set) var dismissSubject = PassthroughSubject<Void, Never>()
    private(set) var prepareForDismissSubject = PassthroughSubject<Void, Never>()
    private(set) var errorAlertSubject = PassthroughSubject<FirestoreError, Never>()

    init(diContainer: DIContainerType) {
        self.diContainer = diContainer

        bind()
    }

    func start(with photo: PhotoDVO) -> UINavigationController {
        let viewModel = MapPhotoViewModel(coordinator: self, diContainer: diContainer, photo: photo)
        let vc = MapPhotoViewController.newInstanse(viewModel: viewModel)
        navigationController.pushViewController(vc, animated: true)

        return navigationController
    }

    private func bind() {
        prepareForDismissSubject
            .map { [weak self] in self?.dismissScreen() }
            .subscribe(dismissSubject)
            .store(in: cancelBag)
        
        errorAlertSubject
            .sink(receiveValue: { [weak self] error in self?.showErrorAlert(error: error) })
            .store(in: cancelBag)
    }
    
    private func dismissScreen() {
        navigationController.viewControllers.removeAll()
        navigationController.dismiss(animated: true)
        print(navigationController.viewControllers)
    }

    // MARK: - deinit
    deinit {
        print(" - deinit - MapPhotoCoordinator")
        cancelBag.cancel()
    }
}
