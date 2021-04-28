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
    
    init(diContainer: DIContainer,
         coordinator: AuthCoordinator,
         emailValidator: EmailValidator,
         passwordValidator: PasswordValidator) {
        self.authUserService = diContainer.resolve()
        self.coordinator = coordinator
        self.emailValidator = emailValidator
        self.passwordValidator = passwordValidator
    }
    
    var validatedEmail: PassthroughSubject<Bool, EmailValidationError>
    
    var validatedPassword: PassthroughSubject<Bool, PasswordValidationError>
    
    var isAuthEnabled: PassthroughSubject<Bool, Error>
    
    @Published var email = ""
    @Published var password = ""
    
}

extension SignInViewModel {
    func transform() {
        
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

extension SignInViewModel {
    private func validateEmail(email: String) -> AnyPublisher<Bool, EmailValidationError> {
      
    }
    private func validatePassword(password: String) -> AnyPublisher<Bool, PasswordValidationError> {}
    
    private func isAuthenticationEnabled() -> AnyPublisher<Bool, Error> {
        
    }
}
