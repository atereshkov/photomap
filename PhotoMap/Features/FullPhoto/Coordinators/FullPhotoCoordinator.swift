//
//  FullPhotoCoordinator.swift
//  PhotoMap
//
//  Created by yurykasper on 21.06.21.
//

import Combine
import UIKit

class FullPhotoCoordinator: Coordinator {
    private(set) var childCoordinators = [Coordinator]()
    private(set) var navigationController = UINavigationController()
    
    private(set) var dismissSubject = PassthroughSubject<Void, Never>()

    init() {}
    
    func start(with photo: PhotoDVO, diContainer: DIContainerType) -> UIViewController {
        let viewModel = FullPhotoViewModel(coordinator: self, diContainer: diContainer, marker: photo)
        let fullPhotoVC = FullPhotoViewController.newInstance(viewModel: viewModel)

        return fullPhotoVC
    }
}
