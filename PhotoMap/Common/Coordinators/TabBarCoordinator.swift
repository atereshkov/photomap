//
//  TabBarCoordinator.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/15/21.
//

import UIKit

class TabBarCoordinator: Coordinator {
    private(set) var childCoordinators: [Coordinator] = []
    private(set) var navigationController = UINavigationController()
    private weak var tabBarController: UITabBarController?
    private let disposeBag = DisposeBag()

    @discardableResult
    func start() -> UIViewController {
        let tabBarController = UITabBarController()
        tabBarController.tabBar.barTintColor = .white
        tabBarController.tabBar.tintColor = .black

        let libraryCoordinator = OLLibraryCoordinator()
        libraryCoordinator.start()
        childCoordinators.append(libraryCoordinator)

        let accountCoordinator = OLAccountCoordinator()
        accountCoordinator.start()
        childCoordinators.append(accountCoordinator)

        tabBarController.viewControllers = [libraryCoordinator.navigationController,
                                            accountCoordinator.navigationController]
        self.tabBarController = tabBarController
        checkNetworkConnection()

        return tabBarController
    }

    func checkNetworkConnection() {
        Reachability.rx.isReachable
            .subscribe(onNext: { [unowned self] isReachable in
                if !isReachable {
                    closePresentedModalVC()
                    showErrorAlert(error: .networtConnection)
                }
            })
            .disposed(by: disposeBag)
    }

    func showErrorAlert(error: OLAlertErrorHelper) {
        tabBarController?.selectedViewController?.present(generateErrorAlert(with: error), animated: true)
    }

    func openDetailBookFromDeepLink(by id: Int) {
        if let booksCoordinator = childCoordinators[tabBarController!.selectedIndex] as? OLBooksCoordinator {
            closePresentedModalVC()
            booksCoordinator.showDetailBook(by: id)
        }
    }

    private func closePresentedModalVC() {
        if let childVC = tabBarController?.selectedViewController?.presentedViewController {
            childVC.dismiss(animated: true, completion: nil)
        }
    }
}
