//
//  InitialViewModel.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4.05.21.
//

class InitialViewModel: InitialViewModelType {
    
    private(set) weak var coordinator: InitialCoordinator!
    private var authListener: AuthListenerType
    
    init(coordinator: InitialCoordinator, diContainer: DIContainerType) {
        self.coordinator = coordinator
        self.authListener = diContainer.resolve()
    }
    
    func viewDidLoad() {
        coordinator.changeMainScreen(authListener.isAuthorized())
    }
    
}
