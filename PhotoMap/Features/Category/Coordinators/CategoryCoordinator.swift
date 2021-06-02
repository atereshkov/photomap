//
//  CategoryCoordinator.swift
//  PhotoMap
//
//  Created by Yury Kasper on 1.06.21.
//

import UIKit

class CategoryCoordinator: Coordinator {
    private(set) var childCoordinators = [Coordinator]()
    private(set) var navigationController: UINavigationController = UINavigationController()
    private let diContainer: DIContainerType
    
    init(diContainer: DIContainerType) {
        self.diContainer = diContainer
    }
    
    func start() -> UIViewController {
        let viewModel = CategoryViewModel(coordinator: self, diContainer: diContainer)
        let categoryVC = CategoryViewController.newInstance(viewModel: viewModel)
        categoryVC.title = L10n.Categories.NavigationItem.title
        navigationController.pushViewController(categoryVC, animated: true)
        return navigationController
    }
    
    func doneButtonPressed() {
        navigationController.dismiss(animated: true)
    }
}
