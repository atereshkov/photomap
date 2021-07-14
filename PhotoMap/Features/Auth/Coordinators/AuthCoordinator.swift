//
//  AuthCoordinator.swift
//  PhotoMap
//
//  Created by yurykasper on 6.07.21.
//

import Combine
import UIKit

class AuthCoordinator: Coordinator {
    // MARK: - Variables
    private(set) var childCoordinators: [Coordinator] = []
    private(set) var navigationController = UINavigationController()
    private let diContainer: DIContainerType
    private let cancelBag = CancelBag()
    
    // MARK: - Inputs
    private(set) var showSignUpSubject = PassthroughSubject<UIControl, Never>()
    private(set) var successfulAuthorizationSubject = PassthroughSubject<Void, Never>()
    private(set) var showErrorAlertSubject = PassthroughSubject<ResponseError, Never>()
    private(set) var dismissSignUpSubject = PassthroughSubject<Void, Never>()
    private(set) var dismissSubject = PassthroughSubject<Void, Never>()
    
    // MARK: - Initialization
    init(diContainer: DIContainerType) {
        self.diContainer = diContainer
        navigationController.modalPresentationStyle = .overFullScreen
        bind()
    }
    
    private func bind() {
        showSignUpSubject
            .sink(receiveValue: { [weak self] _ in self?.presentSignUpScreen() })
            .store(in: cancelBag)
        
        successfulAuthorizationSubject
            .map { [weak self] in self?.navigationController.dismiss(animated: true) }
            .subscribe(dismissSubject)
            .store(in: cancelBag)
        
        showErrorAlertSubject
            .sink(receiveValue: { [weak self] error in self?.showErrorAlert(error: error) })
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
        let viewModel = SignUpViewModel(diContainer: diContainer, coordinator: self)
        let signUpVC = SignUpViewController.newInstanse(viewModel: viewModel)

        navigationController.pushViewController(signUpVC, animated: true)
    }
    
    // MARK: - Deinit
    deinit {
        cancelBag.cancel()
    }
}
