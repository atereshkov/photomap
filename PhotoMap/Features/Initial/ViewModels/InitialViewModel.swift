//
//  InitialViewModel.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4.05.21.
//

import Combine
import UIKit

class InitialViewModel {
    
    private(set) var coordinator: InitialCoordinator
    private var authListener: AuthListenerType?
    
    private var cancelBag = CancelBag()
    
    init(coordinator: InitialCoordinator, diContainer: DIContainerType) {
        self.coordinator = coordinator
        self.authListener = diContainer.resolve()
    }
    
    // Alex: Better to use reactive approach to handle events from View
    func viewDidLoad() {
        authListener?.isUserAuthorized
            .sink { [weak self] isUserAuth in
                self?.coordinator.changeMainScreen(isUserAuth)
            }
            .store(in: cancelBag)
    }
    
}
