//
//  InitialViewController.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/15/21.
//

import UIKit

class InitialViewController: BaseViewController {
    
    // MARK: - Variables
    
    private var coordinator: AppCoordinator?
    private var reachabilityService: ReachabilityServiceType?
    
    // MARK: - New instanse
    
    static func newInstanse(with coordinator: AppCoordinator,
                            diContainer: DIContainerType?) -> InitialViewController {
        let vc = InitialViewController()
        vc.reachabilityService = diContainer?.resolve()
        vc.coordinator = coordinator

        return vc
    }

    // MARK: - Life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        coordinator?.changeMainScreen()
        reachabilityService?.startNotifier()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        reachabilityService?.stopNotifier()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Asset.whiteColor.color
        activityIndicator.startAnimating()
        setOpacityBackgroundNavigationBar()
    }
    
}
