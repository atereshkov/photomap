//
//  TimelineCoordinator.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/19/21.
//

import UIKit
import Combine

class TimelineCoordinator: Coordinator, CategoriesProtocol {
    private(set) var childCoordinators = [Coordinator]()
    private(set) var navigationController = UINavigationController()
    private let diContainer: DIContainerType
    private let cancelBag = CancelBag()
    
    private(set) var categoryButtonTapped = PassthroughSubject<UIBarButtonItem, Never>()
    private(set) var showErrorAlertSubject = PassthroughSubject<GeneralErrorType, Never>()
    private(set) var didSelectMarkerSubject = PassthroughSubject<PhotoDVO, Never>()
    private(set) var doneButtonPressedWithCategoriesSubject = PassthroughSubject<[Category], Never>()
    
    init(diContainer: DIContainerType) {
        self.diContainer = diContainer
        bind()
    }
    
    private func bind() {
        categoryButtonTapped.sink(receiveValue: { [weak self] _ in
            self?.presentCategoryScreen()
        })
        .store(in: cancelBag)
        
        didSelectMarkerSubject.sink(receiveValue: { [weak self] marker in
            self?.presentFullPhotoScreen(for: marker)
        })
        .store(in: cancelBag)
        
        showErrorAlertSubject.sink(receiveValue: { [weak self] error in
            self?.showError(error: error)
        })
        .store(in: cancelBag)
    }
    
    @discardableResult
    func start() -> UIViewController {
        let viewModel = TimelineViewModel(coordinator: self, diContainer: diContainer)
        let timelineVC = TimelineViewController.newInstanse(viewModel: viewModel)
        timelineVC.tabBarItem.title = L10n.Main.TabBar.Timeline.title
        timelineVC.tabBarItem.image = UIImage(systemName: "calendar")
        navigationController.pushViewController(timelineVC, animated: true)

        return navigationController
    }
    
    private func showError(error: GeneralErrorType) {
        let alertViewController = self.generateErrorAlert(with: error)
        self.navigationController.present(alertViewController, animated: true)
    }
    
    private func presentCategoryScreen() {
        let coordinator = CategoryCoordinator(diContainer: diContainer)
        coordinator.categoriesSubject
            .subscribe(doneButtonPressedWithCategoriesSubject)
            .store(in: cancelBag)
        
        coordinator.dismissSubject
            .sink(receiveValue: { [weak self] in self?.childDidFinish() })
            .store(in: cancelBag)

        navigationController.present(coordinator.start(), animated: true)
        childCoordinators.append(coordinator)
    }
    
    private func presentFullPhotoScreen(for marker: PhotoDVO) {
        let coordinator = FullPhotoCoordinator()
        coordinator.dismissSubject
            .sink(receiveValue: { [weak self] in self?.childDidFinish() })
            .store(in: cancelBag)
  
        let fullPhotoVC = coordinator.start(with: marker, diContainer: diContainer)
        navigationController.pushViewController(fullPhotoVC, animated: true)
        childCoordinators.append(coordinator)
    }
    
    // MARK: - Dismiss child coordinators
    func childDidFinish(_ childCoordinator: Coordinator) {
        childCoordinators.removeAll(where: { $0 === childCoordinator })
    }

    private func childDidFinish() {
        if childCoordinators.last != nil {
            childCoordinators.removeLast()
        }
    }
    
    // MARK: - deinit
    deinit {
        cancelBag.cancel()
    }
}
