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
    
    // MARK: - Input
    
    @Published var email = ""
    @Published var password = ""
    
    // MARK: Output
    
    @Published var emailError: String?
    @Published var passwordError: String?
    var isAuthEnabled = CurrentValueSubject<Bool, Error>(false)

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

func isEmailValid(email: String) -> Bool {
    return email.isEmpty ? false : true
}

extension SignInViewModel {
    func transform() {
        // 1
        $email.map { email in
            return isEmailValid(email: email)
        }
        .sink { result in
            Swift.print(result)
        }
        .store(in: cancelBag)
        
        // 2 - combine based
        
        $email.flatMap { email in
            return self.emailValidator.isEmailValid(email)
        }
        // EmailValidationError
        .map { result in
            return result.localized
        }
        // String
        .receive(on: DispatchQueue.main)
        .assign(to: \.emailError, on: self)
        .store(in: cancelBag)
        
        // isAuthEnabled pseudo language
        
        Publishers.CombineLatest(emailError.publisher, passwordError.publisher)
        .map { emailError, passwordError in
            return emailError == nil & passwordError == nil
        }
        // Bool
        .assign(to: \.isAuthEnabled, on: self) // Published
        .sink { result
            isAuthEnabled.value = result // CurrentValueSubject
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
