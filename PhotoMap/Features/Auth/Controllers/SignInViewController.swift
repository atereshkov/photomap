//
//  SignInViewController.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/19/21.
//

import UIKit
import Combine

class SignInViewController: BaseViewController {
    
    @IBOutlet weak var emailTextField: ErrorTextField!
    @IBOutlet weak var passwordTextField: ErrorTextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    
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
            .subscribe(emailTextField.errorSubject)
            .store(in: cancelBag)

        viewModel.$passwordError
            .subscribe(passwordTextField.errorSubject)
            .store(in: cancelBag)
        
        viewModel.$isAuthEnabled
            .map { $0 }
            .receive(on: RunLoop.main)
            .assign(to: \.isEnabled, on: signInButton)
            .store(in: cancelBag)
        
        viewModel.isHiddenLoadingIndicator
            .receive(on: RunLoop.main)
            .assign(to: \.isHidden, on: activityIndicator)
            .store(in: cancelBag)
        
        signUpButton.tapPublisher
            .subscribe(viewModel.signUpButtonSubject)
            .store(in: cancelBag)
        
        signInButton.tapPublisher
            .subscribe(viewModel.signInButtonSubject)
            .store(in: cancelBag)
    }
    
}
