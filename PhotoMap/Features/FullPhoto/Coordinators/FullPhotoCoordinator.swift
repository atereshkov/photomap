//
//  FullPhotoCoordinator.swift
//  PhotoMap
//
//  Created by yurykasper on 21.06.21.
//

import Combine
import UIKit

class FullPhotoCoordinator: ChildCoordinator {
    private(set) var childCoordinators = [Coordinator]()
    private(set) var navigationController = UINavigationController()
    private let diContainer: DIContainerType
    private let cancelBag = CancelBag()
    
    private(set) var dismissSubject = PassthroughSubject<Void, Never>()
    
    init(diContainer: DIContainerType) {
        self.diContainer = diContainer
    }
    
    func start(with marker: PhotoDVO) -> UIViewController {
        let viewModel = FullPhotoViewModel(coordinator: self, diContainer: diContainer, marker: marker)
        let fullPhotoVC = FullPhotoViewController.newInstance(viewModel: viewModel)
        return fullPhotoVC
    }
    
    // MARK: - deinit
    deinit {
        cancelBag.cancel()
    }
}
