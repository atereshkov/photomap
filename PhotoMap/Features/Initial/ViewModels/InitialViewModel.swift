//
//  InitialViewModel.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4.05.21.
//

import Combine

class InitialViewModel: InitialViewModelType {
    
    private(set) var coordinator: InitialCoordinator
    private var authListener: AuthListenerType
    private var cancelBag = CancelBag()
    
    init(coordinator: InitialCoordinator, diContainer: DIContainerType) {
        self.coordinator = coordinator
        self.authListener = diContainer.resolve()
    }
    
    func viewDidLoad() {
        coordinator.changeMainScreen(authListener.isAuthorized())
    }
    
}
