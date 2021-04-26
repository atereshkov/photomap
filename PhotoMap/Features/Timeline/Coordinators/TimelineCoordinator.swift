//
//  TimelineCoordinator.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/19/21.
//

import UIKit
import Combine

class TimelineCoordinator: Coordinator {
    
    private(set) var childCoordinators = [Coordinator]()
    private(set) var navigationController = UINavigationController()
    
    func start() {
        navigationController.tabBarItem.title = L10n.Main.TabBar.Timeline.title
        navigationController.tabBarItem.image = UIImage(named: "calendar")
        navigationController.navigationBar.prefersLargeTitles = true

        let vc = TimelineViewController()

        navigationController.pushViewController(vc, animated: true)
    }
    
}
