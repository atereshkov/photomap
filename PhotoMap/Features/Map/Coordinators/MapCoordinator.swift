//
//  MapCoordinator.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/19/21.
//

import UIKit
import Combine
import CoreLocation

class MapCoordinator: Coordinator, CategoriesProtocol, ImagePickerProtocol {
    private(set) var childCoordinators = [Coordinator]()
    private(set) var navigationController = UINavigationController()

    private let cancelBag = CancelBag()
    private var coordinate: CLLocationCoordinate2D?
    private let diContainer: DIContainerType

    private(set) var showPhotoMenuAlertSubject = PassthroughSubject<CLLocationCoordinate2D?, Never>()
    private(set) var showMapPopupSubject = PassthroughSubject<Photo, Never>()
    private(set) var disableLocationSubject = PassthroughSubject<Void, Never>()
    private(set) var imagePickerSourceSubject = PassthroughSubject<UIImagePickerController.SourceType, Never>()
    private(set) var showImagePickerSubject = PassthroughSubject<UIImagePickerController, Never>()
    private(set) var errorAlertSubject = PassthroughSubject<FirestoreError, Never>()
    private(set) var doneButtonPressedWithCategoriesSubject = PassthroughSubject<[Category], Never>()
    private(set) var showCategoriesScreenSubject = PassthroughSubject<Void, Never>()

    init(diContainer: DIContainerType) {
        self.diContainer = diContainer
        bind()
    }

    @discardableResult
    func start() -> UIViewController {
        let viewModel = MapViewModel(coordinator: self, diContainer: diContainer)
        let mapVC = MapViewController.newInstanse(viewModel: viewModel)
        navigationController.pushViewController(mapVC, animated: true)

        return navigationController
    }

    private func bind() {
        showCategoriesScreenSubject
            .sink { [weak self] _ in
                self?.showCategoryScreen()
            }
            .store(in: cancelBag)
        showPhotoMenuAlertSubject
            .sink { [weak self] coordinate in
                guard let self = self else { return }

                self.coordinate = coordinate
                self.showPhotoMenuAlert()
            }
            .store(in: cancelBag)
        showMapPopupSubject
            .sink { [weak self] photo in
                guard let self = self else { return }

                self.childCoordinators.removeAll()
                let vc = MapPhotoCoordinator(diContainer: self.diContainer).start(with: photo)
                self.navigationController.present(vc, animated: true)
            }
            .store(in: cancelBag)
        disableLocationSubject
            .sink(receiveValue: { [weak self] _ in
                self?.showDisableLocationAlert()
            })
            .store(in: cancelBag)
        imagePickerSourceSubject
            .sink(receiveValue: { [weak self] source in
                guard let self = self,
                      let coordinate = self.coordinate else { return }

                let imagePickerCoordinator = ImagePickerCoordinator(coordinate: coordinate)
                imagePickerCoordinator.selectedPhotoSubject
                    .subscribe(self.showMapPopupSubject)
                    .store(in: self.cancelBag)

                self.childCoordinators.append(imagePickerCoordinator)
                self.navigationController.present(imagePickerCoordinator.start(from: source), animated: true)
            })
            .store(in: cancelBag)
        errorAlertSubject
            .sink(receiveValue: { [weak self] error in self?.showErrorAlert(error: error) })
            .store(in: cancelBag)
    }
}

// MARK: - MapCoordinator extenion with alerts
extension MapCoordinator {
    private func showDisableLocationAlert() {
        let goSettingsAction = UIAlertAction(title: L10n.Main.Map.DisableLocationAlert.Button.Title.settings,
                                             style: .default,
                                             handler: { _ in
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }

            if UIApplication.shared.canOpenURL(url) {
              UIApplication.shared.open(url, completionHandler: nil)
            }
          })
        let cancelAction = UIAlertAction(title: L10n.Main.Map.DisableLocationAlert.Button.Title.close,
                                         style: .cancel,
                                         handler: nil)
        let alert = UIAlertController(title: L10n.Main.Map.DisableLocationAlert.title,
                                      message: L10n.Main.Map.DisableLocationAlert.message,
                                      preferredStyle: .alert)
        alert.addAction(goSettingsAction)
        alert.addAction(cancelAction)

        navigationController.present(alert, animated: true, completion: nil)
    }
}

// MARK: - MapCoordinator extenion for ImagePickerProtocol
extension MapCoordinator {
    private func showPhotoMenuAlert() {
        let doPhotoAction = UIAlertAction(title: L10n.Main.PhotoAlert.Button.Title.takePicture,
                                          style: .default,
                                          handler: { [weak self] _ in self?.imagePickerSourceSubject.send(.camera)})
        let chooseFromLibraryAction = UIAlertAction(title: L10n.Main.PhotoAlert.Button.Title.chooseFromLibrary,
                                                    style: .default,
                                                    handler: { [weak self] _ in
                                                        self?.imagePickerSourceSubject.send(.photoLibrary)
                                                    })
        let cancelAction = UIAlertAction(title: L10n.Main.PhotoAlert.Button.Title.cancel,
                                         style: .cancel,
                                         handler: nil)
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(doPhotoAction)
        alert.addAction(chooseFromLibraryAction)
        alert.addAction(cancelAction)

        navigationController.present(alert, animated: true, completion: nil)
    }
}

// MARK: - MapCoordinator extenion for CategoriesProtocol
extension MapCoordinator {
    private func showCategoryScreen() {
        let coordinator = CategoryCoordinator(diContainer: diContainer)
        coordinator.parentCoordinator = self
        let categoryNavigationVC = coordinator.start()
        categoryNavigationVC.modalPresentationStyle = .fullScreen
        navigationController.present(categoryNavigationVC, animated: true)
        childCoordinators.append(coordinator)
    }
}
