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
    private let activityIndicator = ActivityIndicator()

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
    
}

extension SignUpViewModel {
    
    func transform() {
        $username.flatMap { username in
            return self.usernameValidator.isUsernameValid(username)
        }
        .map { result in
            return result.localized
        }
        .receive(on: DispatchQueue.main)
        .assign(to: \.usernameError, on: self)
        .store(in: cancelBag)
        
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
        .assign(to: \.isRegistrationEnabled, on: self)
        .store(in: cancelBag)
        
        signUpButtonSubject
            .sink { [weak self] _ in
                self?.signUpButtonTapped()
            }
            .store(in: cancelBag)
    }
    
}

extension SignUpViewModel: SignUpViewModelInput {
    
    func signUpButtonTapped() {
        authUserService
            .signUp(email: email, password: password)
            .receive(on: DispatchQueue.main)
            .trackActivity(activityIndicator)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }

                switch completion {
                case .failure:
                    self.coordinator.showErrorAlert(error: ResponseError.registrationError)
                case .finished:
                    self.coordinator.showMap()
                }
            }, receiveValue: { _ in })
            .store(in: cancelBag)
    }
    
}
