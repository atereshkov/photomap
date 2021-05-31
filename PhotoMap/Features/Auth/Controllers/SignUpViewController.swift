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
}

// MARK: ViewModel Bind

extension SignUpViewController {

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

        signUpButton.tapPublisher
            .subscribe(viewModel.signUpButtonSubject)
            .store(in: cancelBag)

        viewModel.$usernameError
            .subscribe(usernameTextField.errorSubject)
            .store(in: cancelBag)

        viewModel.$emailError
            .subscribe(emailTextField.errorSubject)
            .store(in: cancelBag)

        viewModel.$passwordError
            .subscribe(passwordTextField.errorSubject)
            .store(in: cancelBag)
        
        viewModel.$isRegistrationEnabled
            .map { $0 }
            .assign(to: \.isEnabled, on: signUpButton)
            .store(in: cancelBag)

        viewModel.isHiddenLoadingIndicator
            .assign(to: \.isHidden, on: activityIndicator)
            .store(in: cancelBag)
    }
}
