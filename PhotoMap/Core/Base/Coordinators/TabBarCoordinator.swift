//
//  TabBarCoordinator.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/15/21.
//

import UIKit
import Combine

class TabBarCoordinator: Coordinator {
    
    private(set) var childCoordinators: [Coordinator] = []
    private(set) var navigationController = UINavigationController()
    private weak var tabBarController: UITabBarController?
    private var reachabilityService: ReachabilityServiceType?
    
    private var subscriptions = Set<AnyCancellable>()
    private let diContainer: DIContainerType
    
    init(diContainer: DIContainerType) {
        self.diContainer = diContainer
        self.reachabilityService = diContainer.resolve()
    }

    @discardableResult
    func start() -> UIViewController {
        let tabBarController = UITabBarController()
        tabBarController.tabBar.barTintColor = Asset.tabBarBarTintColor.color
        tabBarController.tabBar.tintColor = Asset.tabBarTintColor.color

        let mapCoordinator = MapCoordinator(diContainer: diContainer)
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
        reachabilityService?.checkNetworkConnection()
            .sink(receiveValue: { [weak self] isReachable in
                if !isReachable {
                    self?.closePresentedModalVC()
                    self?.showErrorAlert(error: .networtConnection)
                }
            })
            .store(in: &subscriptions)
    }

    func showErrorAlert(error: AlertError) {
        tabBarController?.selectedViewController?.present(generateErrorAlert(with: error), animated: true)
    }

    private func closePresentedModalVC() {
        if let childVC = tabBarController?.selectedViewController?.presentedViewController {
            childVC.dismiss(animated: true, completion: nil)
        }
    }
    
}
