//
//  LoadingViewController.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/15/21.
//

import UIKit
import Reachability

class LoadingViewController: BaseViewController {
    //MARK: - Variables
    private var coordinator: AppCoordinator?
    private let reachability: Reachability! = try? Reachability()

    //MARK: - New instanse
    static func newInstanse(with coordinator: AppCoordinator) -> LoadingViewController {
        let vc = LoadingViewController()
        vc.coordinator = coordinator

        return vc
    }

    //MARK: - Life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        coordinator?.changeMainScreen()
        try? reachability.startNotifier()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        reachability.stopNotifier()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        activityIndicator.startAnimating()
        setOpacityBackgroundNavigationBar()
    }
}
