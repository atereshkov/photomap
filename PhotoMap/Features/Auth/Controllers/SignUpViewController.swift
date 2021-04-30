//
//  SignUpViewController.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/19/21.
//

import UIKit

class SignUpViewController: BaseViewController {
    
    @IBOutlet weak var usernameTextField: ATCTextField!
    @IBOutlet weak var emailTextField: ATCTextField!
    @IBOutlet weak var passwordTextField: ATCTextField!
    
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
                    self.usernameTextField.addRightView(txtField: self.usernameTextField, str: error)
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
                    self.emailTextField.addRightView(txtField: self.emailTextField, str: error)
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
                    self.passwordTextField.addRightView(txtField: self.passwordTextField, str: error)
                }
            }
            .store(in: cancelBag)
        
        viewModel.$isRegistrationEnabled
            .map { $0 }
            .receive(on: RunLoop.main)
            .assign(to: \.isEnabled, on: signUpButton)
            .store(in: cancelBag)
        
    }
    
}
