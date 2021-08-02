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

    private(set) var dismissSubject = PassthroughSubject<Void, Never>()
    
    init(diContainer: DIContainerType) {
        self.diContainer = diContainer
        self.reachabilityService = diContainer.resolve()
    }

    @discardableResult
    func start() -> UIViewController {
        let tabBarController = UITabBarController()
        tabBarController.modalPresentationStyle = .overFullScreen
        tabBarController.tabBar.barTintColor = Asset.tabBarBarTintColor.color
        tabBarController.tabBar.tintColor = Asset.tabBarTintColor.color

        let mapCoordinator = MapCoordinator(diContainer: diContainer)
        mapCoordinator.start()
        childCoordinators.append(mapCoordinator)
        
        let timelineCoordinator = TimelineCoordinator(diContainer: diContainer)
        timelineCoordinator.start()
        childCoordinators.append(timelineCoordinator)

        let profileCoordinator = ProfileCoordinator(diContainer: diContainer)
        profileCoordinator.dismissSubject
            .map { [weak self] in self?.dismiss() }
            .subscribe(dismissSubject)
            .store(in: &subscriptions)

        profileCoordinator.start()
        childCoordinators.append(profileCoordinator)

        tabBarController.viewControllers = [mapCoordinator.navigationController,
                                            timelineCoordinator.navigationController,
                                            profileCoordinator.navigationController]
        self.tabBarController = tabBarController
        checkNetworkConnection()

        return tabBarController
    }

    private func dismiss() {
        childCoordinators.removeAll()
        tabBarController?.viewControllers?.removeAll()
        tabBarController?.dismiss(animated: true)
    }

    func checkNetworkConnection() {
        reachabilityService?.checkNetworkConnection()
            .sink(receiveValue: { [weak self] isReachable in
                if !isReachable {
                    self?.closePresentedModalVC()
                    self?.showErrorAlert(error: .networkConnection)
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
