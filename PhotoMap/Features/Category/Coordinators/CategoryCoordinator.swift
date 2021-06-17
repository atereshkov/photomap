//
//  CategoryCoordinator.swift
//  PhotoMap
//
//  Created by Yury Kasper on 1.06.21.
//

import Combine
import UIKit

class CategoryCoordinator: Coordinator {
    private(set) var childCoordinators = [Coordinator]()
    private(set) var navigationController: UINavigationController = UINavigationController()
    private let diContainer: DIContainerType
    private let cancelBag = CancelBag()
    
    weak var parentCoordinator: (Coordinator & CategoriesProtocol)?
    
    private(set) var doneButtonSubject = PassthroughSubject<Void, Never>()
    private(set) var showErrorAlertSubject = PassthroughSubject<GeneralErrorType, Never>()
    private(set) var categoriesSubject = PassthroughSubject<[Category], Never>()
    
    init(diContainer: DIContainerType) {
        self.diContainer = diContainer
        bind()
    }
    
    private func bind() {
        doneButtonSubject.sink(receiveValue: { [weak self] in
            self?.doneButtonPressed()
        })
        .store(in: cancelBag)
        
        showErrorAlertSubject.sink(receiveValue: { [weak self] error in
            self?.showErrorAlert(error: error)
        })
        .store(in: cancelBag)
        
        categoriesSubject.sink(receiveValue: { [weak self] categories in
            self?.parentCoordinator?.doneButtonPressedWithCategoriesSubject.send(categories)
        }).store(in: cancelBag)
    }
    
    func start() -> UIViewController {
        let viewModel = CategoryViewModel(coordinator: self, diContainer: diContainer)
        let categoryVC = CategoryViewController.newInstance(viewModel: viewModel)
        categoryVC.title = L10n.Categories.NavigationItem.title
        navigationController.pushViewController(categoryVC, animated: true)
        return navigationController
    }
    
    private func doneButtonPressed() {
        parentCoordinator?.childDidFinish(self)
        navigationController.dismiss(animated: true)
    }
    
    private func showErrorAlert(error: GeneralErrorType) {
        let alertController = self.generateErrorAlert(with: error)
        self.navigationController.present(alertController, animated: true)
    }
}
