//
//  MoreCoordinator.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/19/21.
//

import UIKit
import Combine

class MoreCoordinator: Coordinator {
    
    private(set) var childCoordinators = [Coordinator]()
    private(set) var navigationController = UINavigationController()
    
    func start() {
        navigationController.tabBarItem.title = "More"
        navigationController.tabBarItem.image = UIImage(named: "pencil.circle")
        navigationController.navigationBar.prefersLargeTitles = true

        let vc = MoreViewController()

        navigationController.pushViewController(vc, animated: true)
    }
}
