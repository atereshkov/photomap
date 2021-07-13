//
//  SignInCoordinator.swift
//  PhotoMap
//
//  Created by yurykasper on 6.07.21.
//

import Combine
import UIKit

class SignInCoordinator: Coordinator {
    // MARK: - Variables
    private(set) var childCoordinators: [Coordinator] = []
    private(set) var navigationController = UINavigationController()
    private let authListenerService: AuthListenerType
    private let diContainer: DIContainerType
    private let cancelBag = CancelBag()
    
    weak var parentCoordinator: (AppCoordinatorType & Coordinator)?
    
    private(set) var showSignUpSubject = PassthroughSubject<UIControl, Never>()
    private(set) var showMapSubject = PassthroughSubject<Void, Never>()
    private(set) var showErrorAlertSubject = PassthroughSubject<ResponseError, Never>()
    
    // MARK: - Lifecycle
    init(diContainer: DIContainerType) {
        self.diContainer = diContainer
        self.authListenerService = diContainer.resolve()
        bind()
    }
    
    private func bind() {
        showSignUpSubject.sink(receiveValue: { [weak self] _ in
            self?.presentSignUpScreen()
        })
        .store(in: cancelBag)
        
        showMapSubject.sink(receiveValue: { [weak self] in
            self?.presentMapScreen()
        })
        .store(in: cancelBag)
        
        showErrorAlertSubject.sink(receiveValue: { [weak self] error in
            self?.showErrorAlert(error: error)
        })
        .store(in: cancelBag)
    }
    
    // MARK: - Helpers
    @discardableResult
    func start() -> UIViewController {
        let viewModel = SignInViewModel(diContainer: diContainer, coordinator: self)
        let signInVC = SignInViewController.newInstanse(viewModel: viewModel)
        navigationController.pushViewController(signInVC, animated: true)
        return navigationController
    }
    
    /// - Shows Registration screen
    private func presentSignUpScreen() {
        let signUpCoordinator = SignUpCoordinator(diContainer: diContainer)
        
        signUpCoordinator.dismissSubject.sink(receiveValue: { [weak self] in
            self?.childDidFinish(signUpCoordinator)
            self?.presentMapScreen()
        })
        .store(in: cancelBag)

        signUpCoordinator.backToLoginScreenSubject.sink(receiveValue: { [weak self] in
            self?.childDidFinish(signUpCoordinator)
        })
        .store(in: cancelBag)

        let signUpVC = signUpCoordinator.start()
        navigationController.pushViewController(signUpVC, animated: true)
        childCoordinators.append(signUpCoordinator)
    }
    
    /// - On successful login shows main screen with map
    final func presentMapScreen() {
        navigationController.dismiss(animated: true)
        parentCoordinator?.childDidFinish(self)
        parentCoordinator?.startMainScreen(isUserAuthorized: authListenerService.isAuthorized())
    }
    
    func childDidFinish(_ childCoordinator: Coordinator) {
        childCoordinators.removeAll(where: { $0 === childCoordinator })
    }
    
    deinit {
        cancelBag.cancel()
    }
}
