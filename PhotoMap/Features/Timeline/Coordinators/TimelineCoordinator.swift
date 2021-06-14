//
//  TimelineCoordinator.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/19/21.
//

import UIKit
import Combine

protocol ReturnCategoriesWhenDonePressedProtocol {
    var doneButtonPressedWithCategoriesSubject: PassthroughSubject<[Category], Never> { get }
}

class TimelineCoordinator: Coordinator, ReturnCategoriesWhenDonePressedProtocol {
    private(set) var childCoordinators = [Coordinator]()
    private(set) var navigationController = UINavigationController()
    private let diContainer: DIContainerType
    private let cancelBag = CancelBag()
    
    private(set) var categoryButtonTapped = PassthroughSubject<UIBarButtonItem, Never>()
    private(set) var showErrorAlertSubject = PassthroughSubject<GeneralErrorType, Never>()
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
        
        showErrorAlertSubject.sink(receiveValue: { [weak self] error in
            self?.showError(error: error)
        })
        .store(in: cancelBag)
    }
    
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
        coordinator.parentCoordinator = self
        let categoryNavigationVC = coordinator.start()
        categoryNavigationVC.modalPresentationStyle = .fullScreen
        navigationController.present(categoryNavigationVC, animated: true)
        childCoordinators.append(coordinator)
    }
    
    func childDidFinish(_ childCoordinator: Coordinator) {
        if let index = childCoordinators.firstIndex(where: { coordinator -> Bool in
            return childCoordinator === coordinator
        }) {
            childCoordinators.remove(at: index)
        }
    }
}
