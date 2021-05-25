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
    
    func start() -> UIViewController {
        let viewModel = TimelineViewModel(coordinator: self)
        let timelineVC = TimelineViewController.newInstanse(viewModel: viewModel)
        timelineVC.tabBarItem.title = L10n.Main.TabBar.Timeline.title
        timelineVC.tabBarItem.image = UIImage(systemName: "calendar")
        navigationController.pushViewController(timelineVC, animated: true)

        return navigationController
    }
    
}
