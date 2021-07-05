//
//  CategoryCoordinator.swift
//  PhotoMap
//
//  Created by Yury Kasper on 1.06.21.
//

import Combine
import UIKit

class CategoryCoordinator: ChildCoordinator {
    private(set) var childCoordinators = [Coordinator]()
    private(set) var navigationController: UINavigationController = UINavigationController()
    private let diContainer: DIContainerType
    private let cancelBag = CancelBag()
    
    private(set) var dismissSubject = PassthroughSubject<Void, Never>()
    private(set) var showErrorAlertSubject = PassthroughSubject<GeneralErrorType, Never>()
    private(set) var categoriesSubject = PassthroughSubject<[Category], Never>()
    
    init(diContainer: DIContainerType) {
        self.diContainer = diContainer
        bind()
    }
    
    private func bind() {
        dismissSubject.sink(receiveValue: { [weak self] in
            self?.navigationController.dismiss(animated: true)
        })
        .store(in: cancelBag)
        
        showErrorAlertSubject.sink(receiveValue: { [weak self] error in
            self?.showErrorAlert(error: error)
        })
        .store(in: cancelBag)
    }
    
    func start() -> UIViewController {
        let viewModel = CategoryViewModel(coordinator: self, diContainer: diContainer)
        let categoryVC = CategoryViewController.newInstance(viewModel: viewModel)
        categoryVC.title = L10n.Categories.NavigationItem.title
        navigationController.pushViewController(categoryVC, animated: true)
        return navigationController
    }
    
    private func showErrorAlert(error: GeneralErrorType) {
        let alertController = self.generateErrorAlert(with: error)
        self.navigationController.present(alertController, animated: true)
    }

    // MARK: - deinit
    deinit {
        cancelBag.cancel()
    }
}
