//
//  SignInViewController.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/19/21.
//

import UIKit

class SignInViewController: BaseViewController {
    
    @IBOutlet weak var emailTextField: ATCTextField!
    @IBOutlet weak var passwordTextField: ATCTextField!
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
    
    private func bind() {
        guard let viewModel = viewModel else { return }
        
        emailTextField.textPublisher
            .assign(to: \.email, on: viewModel)
                   .store(in: cancelBag)
        
        passwordTextField.textPublisher
            .assign(to: \.password, on: viewModel)
            .store(in: cancelBag)
        
        viewModel.$isAuthEnabled
            .map { $0 }
            .receive(on: RunLoop.main)
            .assign(to: \.isEnabled, on: loginButton)
//            .sink(receiveValue: { (isEnable) in
//                if isEnable {
//                    self.loginButton.backgroundColor = .purple
//                } else {
//                    self.loginButton.backgroundColor = .gray
//                }
//                self.loginButton.isEnabled = isEnable
//            })
            .store(in: cancelBag)
        
    }
}
