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
    
    private(set) var signUpButtonSubject = PassthroughSubject<UIControl, Never>()
    private(set) var signInButtonSubject = PassthroughSubject<UIControl, Never>()
   
    // MARK: Output
    
    @Published var emailError: String?
    @Published var passwordError: String?
    @Published var isAuthEnabled = false
    
    var showLoadingIndicator = CurrentValueSubject<Bool, Never>(false)
    
    init(diContainer: DIContainerType,
         coordinator: AuthCoordinator,
         emailValidator: EmailValidator,
         passwordValidator: PasswordValidator) {
        self.authUserService = diContainer.resolve()
        self.coordinator = coordinator
        self.emailValidator = emailValidator
        self.passwordValidator = passwordValidator
        
        transform()
    }
    
}

extension SignInViewModel {
    
    func transform() {
        $email.flatMap { email in
            return self.emailValidator.isEmailValid(email)
        }
        .map { result in
            return result.localized
        }
        .receive(on: DispatchQueue.main)
        .assign(to: \.emailError, on: self)
        .store(in: cancelBag)
        
        $password.flatMap { password in
            return self.passwordValidator.isPasswordValid(password)
        }
        .map { result in
            return result.localized
        }
        .receive(on: DispatchQueue.main)
        .assign(to: \.passwordError, on: self)
        .store(in: cancelBag)
        
        let credentials = Publishers.CombineLatest($emailError, $passwordError).eraseToAnyPublisher()
        
        credentials.map { emailError, passwordError in
            return emailError == nil && passwordError == nil
        }
        .assign(to: \.isAuthEnabled, on: self)
        .store(in: cancelBag)
        
        signUpButtonSubject
            .debounce(for: .milliseconds(400), scheduler: RunLoop.main)
            .throttle(for: .milliseconds(20), scheduler: RunLoop.main, latest: true)
            .sink { [weak self] _ in
                self?.signUpButtonTapped()
            }
            .store(in: cancelBag)
        
        signInButtonSubject
            .debounce(for: .milliseconds(400), scheduler: RunLoop.main)
            .throttle(for: .milliseconds(20), scheduler: RunLoop.main, latest: true)
            .sink { [weak self] _ in
                self?.signInButtonTapped()
            }
            .store(in: cancelBag)
    }
    
}

extension SignInViewModel: SignInViewModelInput {
    
    func signInButtonTapped() {
        showLoadingIndicator.send(true)
        authUserService
            .signIn(email: email, password: password)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.showLoadingIndicator.send(false)
                switch completion {
                case .failure:
                    self?.coordinator.showErrorAlert(error: ResponseError.incorrectCredentials)
                case .finished:
                    self?.coordinator.closeScreen()
                }
            }, receiveValue: { _ in })
            .store(in: cancelBag)
    }
    
    func signUpButtonTapped() {
        coordinator.openSignUpScreen()
    }
    
}
