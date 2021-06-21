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
    private let diContainer: DIContainerType
    private let cancelBag = CancelBag()
    
    weak var parentCoordinator: Coordinator?
    private(set) var viewDidDisappearSubject = PassthroughSubject<Void, Never>()
    
    init(diContainer: DIContainerType) {
        self.diContainer = diContainer
        transform()
    }
    
    private func transform() {
        viewDidDisappearSubject.sink(receiveValue: { [weak self] in
            self?.fullPhotoDisappear()
        })
        .store(in: cancelBag)
    }
    
    func start(with marker: Marker) -> UIViewController {
        let viewModel = FullPhotoViewModel(coordinator: self, diContainer: diContainer, marker: marker)
        let fullPhotoVC = FullPhotoViewController.newInstance(viewModel: viewModel)
        return fullPhotoVC
    }
    
    private func fullPhotoDisappear() {
        parentCoordinator?.childDidFinish(self)
    }
}
