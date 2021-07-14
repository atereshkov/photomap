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
    
    private var viewModel: SignUpViewModelType?
    private let cancelBag = CancelBag()
    
    static func newInstanse(viewModel: SignUpViewModel) -> SignUpViewController {
        let signUpVC = StoryboardScene.Authentication.signUpViewController.instantiate()
        signUpVC.viewModel = viewModel
        
        return signUpVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setOpacityBackgroundNavigationBar()
        bind()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
  
        viewModel?.viewDidDisappearSubject.send()
    }
    
    // MARK: - Deinit
    deinit {
        cancelBag.cancel()
    }
}

// MARK: ViewModel Bind

extension SignUpViewController {

    private func bind() {
        guard let viewModel = viewModel as? SignUpViewModel else { return }
        
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

        viewModel.loadingPublisher
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] isLoading in
                isLoading ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
            })
            .store(in: cancelBag)
    }
}
