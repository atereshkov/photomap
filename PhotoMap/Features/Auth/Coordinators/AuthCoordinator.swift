//
//  AuthCoordinator.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/19/21.
//

import UIKit
import Combine

class AuthCoordinator: AuthCoordinatorType {   
   
    private(set) var childCoordinators = [Coordinator]()
    private(set) var navigationController = UINavigationController()
    private var appCoordinator: AppCoordinator?
    private let diContainer: DIContainerType
    private let cancelBag = CancelBag()

    private(set) var showErrorAlertSubject = PassthroughSubject<ResponseError, Never>()
    private(set) var showMapSubject = PassthroughSubject<Void, Never>()
    private(set) var showSignUpSubject = PassthroughSubject<Void, Never>()
    
    init(appCoordinator: AppCoordinator, diContainer: DIContainerType) {
        self.appCoordinator = appCoordinator
        self.diContainer = diContainer
        bind()
    }

    private func bind() {
        showErrorAlertSubject
            .sink { [weak self] error in
                self?.showErrorAlert(error: error)
            }
            .store(in: cancelBag)

        showMapSubject
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }

                self.navigationController.dismiss(animated: true)
                self.appCoordinator?.startMainScreen(isUserAuthorized: true)
            })
            .store(in: cancelBag)

        showSignUpSubject
            .sink { [weak self] _ in
                guard let self = self else { return }

                let viewModel = SignUpViewModel(diContainer: self.diContainer,
                                                coordinator: self, usernameValidator: UsernameValidator(),
                                                emailValidator: EmailValidator(),
                                                passwordValidator: PasswordValidator())
                let signUpVC = SignUpViewController.newInstanse(viewModel: viewModel)
                self.navigationController.pushViewController(signUpVC, animated: true)
            }
            .store(in: cancelBag)
    }

    @discardableResult
    func start() -> UIViewController {
        let viewModel = SignInViewModel(diContainer: diContainer,
                                        coordinator: self,
                                        emailValidator: EmailValidator(),
                                        passwordValidator: PasswordValidator())
        let signInVC = SignInViewController.newInstanse(viewModel: viewModel)
        navigationController.pushViewController(signInVC, animated: true)
        
        return navigationController
    }
    
    private func showErrorAlert(error: ResponseError) {
        let alert = UIAlertController(title: error.title,
                                      message: error.message,
                                      preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: L10n.ok,
                                         style: .cancel) { [unowned self] _ in
            if case .networkError = error { self.navigationController.popViewController(animated: true) }
        }

        alert.addAction(cancelAction)
        self.navigationController.present(alert, animated: true)
    }
}
