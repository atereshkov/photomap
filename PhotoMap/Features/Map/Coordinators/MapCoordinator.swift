//
//  MapCoordinator.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/19/21.
//

import UIKit
import Combine

class MapCoordinator: Coordinator {
    
    private(set) var childCoordinators = [Coordinator]()
    private(set) var navigationController = UINavigationController()
    private let diContainer: DIContainerType
    private let cancelBag = CancelBag()
    private(set) var showPhotoMenuAlertSubject = PassthroughSubject<Void, Never>()
    private(set) var showMapPopupSubject = PassthroughSubject<Photo, Never>()
    private(set) var disableLocationSubject = PassthroughSubject<Void, Never>()
    private(set) var imagePickerSourceSubject = PassthroughSubject<UIImagePickerController.SourceType, Never>()
    private(set) var showImagePickerSubject = PassthroughSubject<UIImagePickerController, Never>()

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
        showPhotoMenuAlertSubject
            .sink { [weak self] _ in
                self?.showPhotoMenuAlert()
            }
            .store(in: cancelBag)
        showMapPopupSubject
            .sink { [weak self] photo in
                guard let self = self else { return }

                let vc = MapPhotoCoordinator(diContainer: self.diContainer).start(photo: photo)
                self.navigationController.present(vc, animated: true)
            }
            .store(in: cancelBag)
        disableLocationSubject
            .sink(receiveValue: { [weak self] _ in
                self?.showDisableLocationAlert()
            })
            .store(in: cancelBag)
        showImagePickerSubject
            .sink(receiveValue: { [weak self] picker in
                self?.navigationController.present(picker, animated: true)
            })
            .store(in: cancelBag)
    }
    
    private func showPhotoMenuAlert() {
        let doPhotoAction = UIAlertAction(title: L10n.Main.PhotoAlert.Button.Title.takePicture,
                                          style: .default,
                                          handler: { [weak self] _ in self?.imagePickerSourceSubject.send(.camera)})
        let chooseFromLibraryAction = UIAlertAction(title: L10n.Main.PhotoAlert.Button.Title.chooseFromLibrary,
                                                    style: .default,
                                                    handler: { [weak self] _ in self?.imagePickerSourceSubject.send(.photoLibrary)})
        let cancelAction = UIAlertAction(title: L10n.Main.PhotoAlert.Button.Title.cancel,
                                         style: .cancel,
                                         handler: nil)
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(doPhotoAction)
        alert.addAction(chooseFromLibraryAction)
        alert.addAction(cancelAction)

        navigationController.present(alert, animated: true, completion: nil)
    }

    private func showDisableLocationAlert() {
        let goSettingsAction = UIAlertAction(title: L10n.Main.Map.DisableLocationAlert.Button.Title.settings,
                                             style: .default,
                                             handler: { _ in
            guard let url = URL(string: UIApplication.openSettingsURLString) else {
              return
            }

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
