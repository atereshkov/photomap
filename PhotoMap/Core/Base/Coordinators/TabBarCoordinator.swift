//
//  TabBarCoordinator.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/15/21.
//

import UIKit
import Combine
import Reachability

class TabBarCoordinator: Coordinator {
    private(set) var childCoordinators: [Coordinator] = []
    private(set) var navigationController = UINavigationController()
    private weak var tabBarController: UITabBarController?
    
    private var subscriptions = Set<AnyCancellable>()

    @discardableResult
    func start() -> UIViewController {
        let tabBarController = UITabBarController()
        tabBarController.tabBar.barTintColor = .white
        tabBarController.tabBar.tintColor = .black

        let mapCoordinator = MapCoordinator()
        mapCoordinator.start()
        childCoordinators.append(mapCoordinator)
        
        let timelineCoordinator = TimelineCoordinator()
        timelineCoordinator.start()
        childCoordinators.append(timelineCoordinator)

        let moreCoordinator = MoreCoordinator()
        moreCoordinator.start()
        childCoordinators.append(moreCoordinator)

        tabBarController.viewControllers = [mapCoordinator.navigationController,
                                            timelineCoordinator.navigationController,
                                            moreCoordinator.navigationController]
        self.tabBarController = tabBarController
        checkNetworkConnection()

        return tabBarController
    }

    func checkNetworkConnection() {
        Reachability.isReachable
            .sink(receiveValue: { [weak self] isReachable in
                if !isReachable {
                    self?.closePresentedModalVC()
                    self?.showErrorAlert(error: .networtConnection)
                }
            })
            .store(in: &subscriptions)
    }

    func showErrorAlert(error: AlertErrorHelper) {
        tabBarController?.selectedViewController?.present(generateErrorAlert(with: error), animated: true)
    }

    private func closePresentedModalVC() {
        if let childVC = tabBarController?.selectedViewController?.presentedViewController {
            childVC.dismiss(animated: true, completion: nil)
        }
    }
}
