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
        navigationController.navigationBar.prefersLargeTitles = true

        let vc = MoreViewController()
        vc.tabBarItem.title = L10n.Main.TabBar.More.title
        vc.tabBarItem.image = UIImage(named: "pencil.circle")

        navigationController.pushViewController(vc, animated: true)
    }
}
