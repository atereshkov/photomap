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
    // MARK: - Variables
    private(set) var childCoordinators = [Coordinator]()
    private(set) var navigationController = UINavigationController()

    private let cancelBag = CancelBag()
    private var coordinate: CLLocationCoordinate2D?
    private let diContainer: DIContainerType

    // MARK: - Subjects
    private(set) var showPhotoMenuAlertSubject = PassthroughSubject<CLLocationCoordinate2D?, Never>()
    private(set) var showMapPopupSubject = PassthroughSubject<PhotoDVO, Never>()
    private(set) var disableLocationSubject = PassthroughSubject<Void, Never>()
    private(set) var imagePickerSourceSubject = PassthroughSubject<UIImagePickerController.SourceType, Never>()
    private(set) var showImagePickerSubject = PassthroughSubject<UIImagePickerController, Never>()
    private(set) var errorAlertSubject = PassthroughSubject<FirestoreError, Never>()
    private(set) var doneButtonPressedWithCategoriesSubject = PassthroughSubject<[Category], Never>()
    private(set) var showCategoriesScreenSubject = PassthroughSubject<Void, Never>()
    private(set) var showFullPhotoSubject = PassthroughSubject<PhotoDVO, Never>()

    // MARK: - Init & setup
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
            .sink { [weak self] in self?.showCategoryScreen() }
            .store(in: cancelBag)

        showPhotoMenuAlertSubject
            .sink { [weak self] coordinate in
                self?.coordinate = coordinate
                self?.showPhotoMenuAlert()
            }
            .store(in: cancelBag)

        showMapPopupSubject
            .sink { [weak self] photo in self?.showPhotoMapScreen(photo) }
            .store(in: cancelBag)

        showFullPhotoSubject
            .sink { [weak self] photo in self?.showFullPhotoScreen(for: photo) }
            .store(in: cancelBag)

        disableLocationSubject
            .sink { [weak self] in self?.showDisableLocationAlert() }
            .store(in: cancelBag)

        imagePickerSourceSubject
            .sink { [weak self] source in self?.showImagePicker(from: source) }
            .store(in: cancelBag)

        errorAlertSubject
            .sink(receiveValue: { [weak self] error in self?.showErrorAlert(error: error) })
            .store(in: cancelBag)
    }
    
    func childDidFinish() {
        if childCoordinators.last is ChildCoordinator {
            childCoordinators.removeLast()
        }
    }
    
    // MARK: - deinit
    deinit {
        cancelBag.cancel()
    }
}

// MARK: - MapCoordinator extension with alerts
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

// MARK: - MapCoordinator extension for ImagePickerProtocol
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

    private func showImagePicker(from source: UIImagePickerController.SourceType) {
        guard let coordinate = self.coordinate else { return }
        
        let imagePickerCoordinator = ImagePickerCoordinator(coordinate: coordinate)
        imagePickerCoordinator.selectedPhotoSubject
            .sink(receiveValue: { [weak self] photo in self?.showMapPopupSubject.send(photo)})
            .store(in: cancelBag)

        childCoordinators.append(imagePickerCoordinator)
        navigationController.present(imagePickerCoordinator.start(from: source), animated: true)
    }
}

// MARK: - MapCoordinator extension for PhotoMap Screen
extension MapCoordinator {
    private func showPhotoMapScreen(_ photo: PhotoDVO) {
        // - remove imagePickerCoordinator
        childDidFinish()

        let mapPhotoCoordinator = MapPhotoCoordinator(diContainer: diContainer)
        mapPhotoCoordinator.dismissSubject
            .sink(receiveValue: { [weak self] in self?.childDidFinish() })
            .store(in: cancelBag)
           
        childCoordinators.append(mapPhotoCoordinator)
        navigationController.present(mapPhotoCoordinator.start(with: photo), animated: true)
    }
}

// MARK: - MapCoordinator extension for CategoriesProtocol
extension MapCoordinator {
    private func showCategoryScreen() {
        let coordinator = CategoryCoordinator(diContainer: diContainer)
        
        coordinator.categoriesSubject
            .subscribe(doneButtonPressedWithCategoriesSubject)
            .store(in: cancelBag)

        coordinator.dismissSubject
            .sink(receiveValue: { [weak self] _ in self?.childDidFinish() })
            .store(in: cancelBag)

        let categoryNavigationVC = coordinator.start()
        categoryNavigationVC.modalPresentationStyle = .fullScreen
        navigationController.present(categoryNavigationVC, animated: true)
        childCoordinators.append(coordinator)
    }

    private func showFullPhotoScreen(for photo: PhotoDVO) {
        let coordinator = FullPhotoCoordinator(diContainer: diContainer)

        coordinator.dismissSubject
            .sink(receiveValue: { [weak self] _ in
                self?.childDidFinish()
            })
            .store(in: cancelBag)

        let fullPhotoVC = coordinator.start(with: photo)
        navigationController.pushViewController(fullPhotoVC, animated: true)
        childCoordinators.append(coordinator)
    }
    
    private func showPopupView(with photo: PhotoDVO) {
        let mapPhotoCoordinator = MapPhotoCoordinator(diContainer: diContainer)
        mapPhotoCoordinator.parentCoordinator = self
        let mapPhotoVC = mapPhotoCoordinator.start(with: photo)
        navigationController.present(mapPhotoVC, animated: true)
        childCoordinators.append(mapPhotoCoordinator)
    }
    
    private func showImagePicker(coordinate: CLLocationCoordinate2D, from source: UIImagePickerController.SourceType) {
        let imagePickerCoordinator = ImagePickerCoordinator(coordinate: coordinate)
        imagePickerCoordinator.parentCoordinator = self
        
        imagePickerCoordinator.selectedPhotoSubject
            .subscribe(showMapPopupSubject)
            .store(in: cancelBag)
        
        let imagePickerController = imagePickerCoordinator.start(from: source)
        navigationController.present(imagePickerController, animated: true)
        childCoordinators.append(imagePickerCoordinator)
    }
    
    func childDidFinish(_ childCoordinator: Coordinator) {
        childCoordinators.removeAll(where: { $0 === childCoordinator })
    }
}
