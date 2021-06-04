//
//  SignUpViewModel.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/19/21.
//

import FirebaseAuth
import Combine

class SignUpViewModel: SignUpViewModelType {
   
    private(set) var coordinator: AuthCoordinator
    
    private let cancelBag = CancelBag()
    private let authUserService: AuthUserServiceType
    
    private let usernameValidator: UsernameValidator
    private let emailValidator: EmailValidator
    private let passwordValidator: PasswordValidator
    private let activityIndicator = ActivityIndicator()
    
    // MARK: - Input
    @Published var email = ""
    @Published var password = ""
    @Published var username = ""
    
    private(set) var signUpButtonSubject = PassthroughSubject<UIControl, Never>()
    
    // MARK: Output
    @Published var usernameError: String?
    @Published var emailError: String?
    @Published var passwordError: String?
    @Published var isRegistrationEnabled = false
    var loadingPublisher: AnyPublisher<Bool, Never> {
        activityIndicator.loading
    }

    init(diContainer: DIContainerType,
         coordinator: AuthCoordinator,
         usernameValidator: UsernameValidator,
         emailValidator: EmailValidator,
         passwordValidator: PasswordValidator) {
        self.authUserService = diContainer.resolve()
        self.coordinator = coordinator
        self.usernameValidator = usernameValidator
        self.emailValidator = emailValidator
        self.passwordValidator = passwordValidator
        
        transform()
    }

    private func transform() {
        $username
            .flatMap { [unowned self] username in
                self.usernameValidator.isUsernameValid(username)
            }
            .map { $0.localized }
            .receive(on: DispatchQueue.main)
            .assign(to: \.usernameError, on: self)
            .store(in: cancelBag)
        
        $email
            .flatMap { [unowned self] email in
                self.emailValidator.isEmailValid(email)
            }
            .map { $0.localized }
            .receive(on: DispatchQueue.main)
            .assign(to: \.emailError, on: self)
            .store(in: cancelBag)
        
        $password
            .flatMap { [unowned self] password in
                self.passwordValidator.isPasswordValid(password)
            }
            .map { $0.localized }
            .receive(on: DispatchQueue.main)
            .assign(to: \.passwordError, on: self)
            .store(in: cancelBag)
        
        Publishers.CombineLatest3($emailError, $passwordError, $usernameError)
            .map { email, password, name -> Bool in
                if email == nil && password == nil && name == nil {
                    return true
                } else {
                    return false
                }
            }
            .assign(to: \.isRegistrationEnabled, on: self)
            .store(in: cancelBag)
        
        signUpButtonSubject
            .throttle(for: .milliseconds(20), scheduler: RunLoop.main, latest: true)
            .sink { [weak self] _ in self?.signUpButtonTapped() }
            .store(in: cancelBag)
    }
    
}

extension SignUpViewModel {
    
    private func signUpButtonTapped() {
        authUserService
            .signUp(email: email, password: password)
            .receive(on: DispatchQueue.main)
            .trackActivity(activityIndicator)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }

                switch completion {
                case .failure(let error):
                    self.coordinator.showErrorAlertSubject.send(ResponseError(error))
                case .finished:
                    self.coordinator.showMapSubject.send()
                }
            }, receiveValue: { _ in })
            .store(in: cancelBag)
    }
}
