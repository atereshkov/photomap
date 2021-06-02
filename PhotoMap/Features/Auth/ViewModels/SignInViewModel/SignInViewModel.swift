//
//  SignInViewModel.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/19/21.
//

import FirebaseAuth
import Combine

class SignInViewModel: SignInViewModelType {

    private(set) var coordinator: AuthCoordinatorType
    
    private let cancelBag = CancelBag()
    private let authUserService: AuthUserServiceType
    
    private let emailValidator: EmailValidator
    private let passwordValidator: PasswordValidator
    private let activityIndicator = ActivityIndicator()
    
    // MARK: - Input
    @Published var email: String = ""
    @Published var password: String = ""
    
    private(set) var signUpButtonSubject = PassthroughSubject<UIControl, Never>()
    private(set) var signInButtonSubject = PassthroughSubject<UIControl, Never>()

    // MARK: Output
    @Published var emailError: String? = ""
    @Published var passwordError: String? = ""
    @Published var isAuthEnabled = false
    var loadingPublisher: AnyPublisher<Bool, Never> {
        activityIndicator.loading
    }
    
    init(diContainer: DIContainerType,
         coordinator: AuthCoordinatorType,
         emailValidator: EmailValidator,
         passwordValidator: PasswordValidator) {
        self.authUserService = diContainer.resolve()
        self.coordinator = coordinator
        self.emailValidator = emailValidator
        self.passwordValidator = passwordValidator
        
        transform()
    }
    
    private func transform() {
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
        
        Publishers.CombineLatest($emailError, $passwordError)
            .map { $0 == nil && $1 == nil }
            .assign(to: \.isAuthEnabled, on: self)
            .store(in: cancelBag)
        
        signUpButtonSubject
            .debounce(for: .milliseconds(400), scheduler: RunLoop.main)
            .throttle(for: .milliseconds(20), scheduler: RunLoop.main, latest: true)
            .map { _ in () }
            .subscribe(coordinator.showSignUpSubject)
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

extension SignInViewModel {
    
    private func signInButtonTapped() {
        authUserService
            .signIn(email: email, password: password)
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
