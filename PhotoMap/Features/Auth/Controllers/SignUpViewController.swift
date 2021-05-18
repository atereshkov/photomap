//
//  SignUpViewController.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/19/21.
//

import UIKit

class SignUpViewController: BaseViewController {
    
    @IBOutlet weak var usernameTextField: ErrorTextField!
    @IBOutlet weak var emailTextField: ErrorTextField!
    @IBOutlet weak var passwordTextField: ErrorTextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    private var viewModel: SignUpViewModel?
    private let cancelBag = CancelBag()
    
    static func newInstanse(viewModel: SignUpViewModel) -> SignUpViewController {
        let signUpVC = StoryboardScene.Authentication.signUpViewController.instantiate()
        signUpVC.viewModel = viewModel
        signUpVC.tabBarItem.image = .actions
        
        return signUpVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setOpacityBackgroundNavigationBar()
        bind()
    }
    
    @IBAction func signInButtonDidTap(_ sender: Any) {
        viewModel?.signUpButtonTapped()
    }
    
}

// MARK: ViewModel Bind

extension SignUpViewController {
    
    // swiftlint:disable function_body_length
    private func bind() {
        guard let viewModel = viewModel else { return }
        
        usernameTextField.textPublisher
            .assign(to: \.username, on: viewModel)
            .store(in: cancelBag)
        
        emailTextField.textPublisher
            .assign(to: \.email, on: viewModel)
            .store(in: cancelBag)
        
        passwordTextField.textPublisher
            .assign(to: \.password, on: viewModel)
            .store(in: cancelBag)
        
        viewModel.$usernameError
            .receive(on: RunLoop.main)
            .sink { [weak self] error in
                guard let `self` = self else {
                    return
                }
                if let error = error {
                    self.usernameTextField.showError(error)
                } else {
                    self.usernameTextField.hideError()
                }
            }
            .store(in: cancelBag)

        viewModel.$emailError
            .receive(on: RunLoop.main)
            .sink { [weak self] error in
                guard let `self` = self else {
                    return
                }
                if let error = error {
                    self.emailTextField.showError(error)
                } else {
                    self.emailTextField.hideError()
                }
            }
            .store(in: cancelBag)

        viewModel.$passwordError
            .receive(on: RunLoop.main)
            .sink { [weak self] error in
                guard let `self` = self else {
                    return
                }
                if let error = error {
                    self.passwordTextField.showError(error)
                } else {
                    self.passwordTextField.hideError()
                }
            }
            .store(in: cancelBag)
        
        viewModel.$isRegistrationEnabled
            .map { $0 }
            .receive(on: RunLoop.main)
            .assign(to: \.isEnabled, on: signUpButton)
            .store(in: cancelBag)
    }
    // swiftlint:enable function_body_length
}
