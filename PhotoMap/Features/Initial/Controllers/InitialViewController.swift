//
//  InitialViewController.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 3.05.21.
//

import UIKit
import Combine

class InitialViewController: BaseViewController {

    private var coordinator: AppCoordinator?
    private var authListener: AuthListenerType?
    
    private var cancelBag = CancelBag()
    
    static func newInstanse(with coordinator: AppCoordinator, diContainer: DIContainer) -> InitialViewController {
        let initialVC = StoryboardScene.Initial.initialViewController.instantiate()
        initialVC.coordinator = coordinator
        initialVC.authListener = diContainer.resolve()
        
        return initialVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        activityIndicator.startAnimating()
        startListening()
    }
    
    func startListening() {
        authListener?.isUserAuthorized
            .sink { [weak self] isUserAuth in
                self?.coordinator?.startMainScreen(isUserAuthorized: isUserAuth)
            }
            .store(in: cancelBag)
    }
}
