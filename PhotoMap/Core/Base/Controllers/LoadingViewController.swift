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
    private var rechabilityService: ReachabilityServiceType?
    
    // MARK: - New instanse
    static func newInstanse(with coordinator: AppCoordinator,
                            DIHelper: DIHelperType?) -> LoadingViewController {
        let vc = LoadingViewController()
        vc.rechabilityService = DIHelper?.resolve()
        vc.coordinator = coordinator

        return vc
    }

    // MARK: - Life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        coordinator?.changeMainScreen()
        rechabilityService?.startNotifier()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        rechabilityService?.stopNotifier()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        activityIndicator.startAnimating()
        setOpacityBackgroundNavigationBar()
    }
    
}
