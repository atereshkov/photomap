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
    private var diContainer: DIContainerType
    
    private var cancelBag = CancelBag()
    
    init(coordinator: InitialCoordinator, diContainer: DIContainerType) {
        self.coordinator = coordinator
        self.authListener = diContainer.resolve()
        self.diContainer = diContainer
        
        authListener?.isUserAuthorized
            .sink { [weak self] isUserAuth in
                self?.coordinator.changeMainScreen(isUserAuth)
            }
            .store(in: cancelBag)
    }
    
}
