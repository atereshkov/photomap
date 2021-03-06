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
    
    private let validationService: ValidationServiceType
    private let activityIndicator = ActivityIndicator()
    
    // MARK: - Input
    @Published var email: String = ""
    @Published var password: String = ""
    
    private(set) var signUpButtonSubject = PassthroughSubject<UIControl, Never>()
    private(set) var signInButtonSubject = PassthroughSubject<UIControl, Never>()

    // MARK: Output
    @Published var emailError: String?
    @Published var passwordError: String?
    @Published var isAuthEnabled = false
    var loadingPublisher: AnyPublisher<Bool, Never> {
        activityIndicator.loading
    }
    
    init(diContainer: DIContainerType, coordinator: AuthCoordinator) {
        self.authUserService = diContainer.resolve()
        self.coordinator = coordinator
        self.validationService = diContainer.resolve()
        
        transform()
    }
    
    private func transform() {
        $email
            .flatMap { [unowned self] email in
                self.validationService.validateEmail(email)
            }
            .map { $0.localized }
            .receive(on: DispatchQueue.main)
            .assign(to: &$emailError)
        
        $password
            .flatMap { [unowned self] password in
                self.validationService.validatePassword(password)
            }
            .map { $0.localized }
            .receive(on: DispatchQueue.main)
            .assign(to: &$passwordError)
        
        Publishers.CombineLatest($emailError, $passwordError)
            .map { $0 == nil && $1 == nil }
            .assign(to: &$isAuthEnabled)
        
        signUpButtonSubject
            .subscribe(coordinator.showSignUpSubject)
            .store(in: cancelBag)
        
        signInButtonSubject
            .sink { [weak self] _ in self?.signInButtonTapped() }
            .store(in: cancelBag)
    }
    
    deinit {
        cancelBag.cancel()
    }
}

extension SignInViewModel {
    
    private func signInButtonTapped() {
        authUserService
            .signIn(email: email, password: password)
            .receive(on: DispatchQueue.main)
            .trackActivity(activityIndicator)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.coordinator.showErrorAlertSubject.send(ResponseError(error))
                case .finished:
                    self?.coordinator.successfulAuthorizationSubject.send()
                }
            }, receiveValue: { _ in })
            .store(in: cancelBag)
    }
}
