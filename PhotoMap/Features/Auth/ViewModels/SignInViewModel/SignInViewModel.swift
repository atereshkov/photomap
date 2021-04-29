//
//  SignInViewModel.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/19/21.
//

import FirebaseAuth
import Combine

class SignInViewModel: SignInViewModelType {
    
    private(set) var coordinator: AuthCoordinator
    
    private let cancelBag = CancelBag()
    private let authUserService: AuthUserServiceType
    
    private let emailValidator: EmailValidator
    private let passwordValidator: PasswordValidator
    
    @Published var email = ""
    @Published var password = ""
    
    @Published var emailValidationMessage: String = ""
    @Published var passwordValidationMessage: String = ""
    
    var isAuthEnabled = PassthroughSubject<Bool, Error>()
    
    var emailValidationMessagePublisher: Published<String>.Publisher { $emailValidationMessage}
    var passwordValidationMessagePublisher: Published<String>.Publisher { $passwordValidationMessage }

    init(diContainer: DIContainer,
         coordinator: AuthCoordinator,
         emailValidator: EmailValidator,
         passwordValidator: PasswordValidator) {
        self.authUserService = diContainer.resolve()
        self.coordinator = coordinator
        self.emailValidator = emailValidator
        self.passwordValidator = passwordValidator
    }
    
}

extension SignInViewModel {
    func transform() {
        $email.map { [weak self] email in
            self?.emailValidator.isEmailValid(input: email)
        }
        .sink{ [weak self] message in
            guard let self = self else { return }
            self.emailValidationMessage = message
        }
    }
}

extension SignInViewModel: SignInViewModelInput {
    
    func signInButtonTapped() {
        authUserService
            .signIn(email: email, password: password)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure:
                    self?.coordinator.showErrorAlert(error: ResponseError.registrationError)
                case .finished:
                    break
                }
            }, receiveValue: { _ in })
            .store(in: cancelBag)
    }
    
}
