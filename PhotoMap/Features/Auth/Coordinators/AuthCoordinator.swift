//
//  AuthCoordinator.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/19/21.
//

import UIKit

class AuthCoordinator: Coordinator {
    
    private(set) var childCoordinators = [Coordinator]()
    private(set) var navigationController = UINavigationController()
    private var appCoordinator: AppCoordinator?
    
    init(appCoordinator: AppCoordinator) {
        self.appCoordinator = appCoordinator
    }
    
    @discardableResult
    func start() -> UIViewController {
        let viewModel = SignInViewModel(diContainer: DIContainer(),
                                        coordinator: self,
                                        emailValidator: EmailValidator(),
                                        passwordValidator: PasswordValidator())
        let signInVC = SignInViewController.newInstanse(viewModel: viewModel)
        navigationController.pushViewController(signInVC, animated: true)
        
        return navigationController
    }
    
    func openSignUpScreen() {
        let viewModel = SignUpViewModel(diContainer: DIContainer(),
                                        coordinator: self, usernamevalidator: UsernameValidator(),
                                        emailValidator: EmailValidator(),
                                        passwordValidator: PasswordValidator())
        let signUpVC = SignUpViewController.newInstanse(viewModel: viewModel)
        navigationController.pushViewController(signUpVC, animated: true)
    }
    
    func showErrorAlert(error: ResponseError) {
        let alert = UIAlertController(title: error.title,
                                      message: error.message,
                                      preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: L10n.ok,
                                         style: .cancel) { [unowned self] _ in
            if case .networtConnection = error { self.navigationController.popViewController(animated: true) }
        }

        alert.addAction(cancelAction)
        self.navigationController.present(alert, animated: true)
    }
    
    func showMap() {
        self.appCoordinator?.startMainScreen(isUserAuthorized: true)
    }

    func closeScreen() {
        navigationController.dismiss(animated: true, completion: nil)
        self.showMap()
    }
    
}
