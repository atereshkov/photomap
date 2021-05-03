//
//  SignInViewController.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/19/21.
//

import UIKit

class SignInViewController: BaseViewController {
    
    @IBOutlet weak var emailTextField: ErrorTextField!
    @IBOutlet weak var passwordTextField: ErrorTextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
 
    private var viewModel: SignInViewModel?
    private let cancelBag = CancelBag()
    
    static func newInstanse(viewModel: SignInViewModel) -> SignInViewController {
        let signInVC = StoryboardScene.Authentication.signInViewController.instantiate()
        signInVC.viewModel = viewModel
        signInVC.tabBarItem.image = .actions
        
        return signInVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setOpacityBackgroundNavigationBar()
        bind()
    }
    
    @IBAction func signInButtonDidTap(_ sender: Any) {
        viewModel?.signInButtonTapped()
    }
    
    @IBAction func signUpButtonDidTap(_ sender: Any) {
        viewModel?.signUpButtonTapped()
    }
    
}

// MARK: ViewModel Bind

extension SignInViewController {
    
    private func bind() {
        guard let viewModel = viewModel else { return }
        
        emailTextField.textPublisher
            .assign(to: \.email, on: viewModel)
            .store(in: cancelBag)
        
        passwordTextField.textPublisher
            .assign(to: \.password, on: viewModel)
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
        
        viewModel.$isAuthEnabled
            .map { $0 }
            .receive(on: RunLoop.main)
            .assign(to: \.isEnabled, on: loginButton)
            .store(in: cancelBag)
    }
    
}
