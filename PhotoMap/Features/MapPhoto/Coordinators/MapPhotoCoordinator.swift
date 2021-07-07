//
//  MapPhotoCoordinator.swift
//  PhotoMap
//
//  Created by Dzmitry Makarevich on 6.05.21.
//

import UIKit
import Combine

class MapPhotoCoordinator: ChildCoordinator {
    private(set) var childCoordinators: [Coordinator] = []
    private(set) var navigationController = UINavigationController()

    weak var parentCoordinator: Coordinator?
    
    private var cancelBag = CancelBag()
    private let diContainer: DIContainerType
    private(set) var finishedSubject = PassthroughSubject<Void, Never>()
    private(set) var dismissSubject = PassthroughSubject<Void, Never>()
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
        finishedSubject
            .map { [weak self] _ in
                self?.navigationController.dismiss(animated: true)
            }
            .subscribe(dismissSubject)
            .store(in: cancelBag)

        errorAlertSubject
            .sink(receiveValue: { [weak self] error in self?.showErrorAlert(error: error) })
            .store(in: cancelBag)
    }
    
    // MARK: - deinit
    deinit {
        cancelBag.cancel()
}
