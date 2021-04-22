//
//  LoadingViewController.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/15/21.
//

import UIKit

class LoadingViewController: BaseViewController {
    
    // MARK: - Variables
    
    private var coordinator: AppCoordinator?
    private var reachabilityService: ReachabilityServiceType?
    
    // MARK: - New instanse
    
    static func newInstanse(with coordinator: AppCoordinator,
                            DIHelper: DIHelperType?) -> LoadingViewController {
        let vc = LoadingViewController()
        vc.reachabilityService = DIHelper?.resolve()
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
