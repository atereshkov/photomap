//
//  SignInViewModel.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/19/21.
//

import FirebaseAuth
import Combine

protocol SignInViewModelInput {
    var email: String { get set }
    var password: String { get set }
    
    func signInButtonTapped()
}

protocol SignInViewModelOutput {
    var validatedEmail: PassthroughSubject<Bool, EmailValidationError> { get set }
    var validatedPassword: PassthroughSubject<Bool, PasswordValidationError> { get set }
    
    var isAuthEnabled: PassthroughSubject<Bool, Error> { get set }
}

protocol SignInViewModelType: SignInViewModelInput, SignInViewModelOutput {
    
}

class SignInViewModel: SignInViewModelType {
  
    private(set) var coordinator: AuthCoordinator
    
    private let cancelBag = CancelBag()
    private let authUserService: AuthUserServiceType
    
    init(diContainer: DIContainer, coordinator: AuthCoordinator) {
        self.authUserService = diContainer.resolve()
        
        self.coordinator = coordinator
    }
    
    var validatedEmail: PassthroughSubject<Bool, EmailValidationError>
    
    var validatedPassword: PassthroughSubject<Bool, PasswordValidationError>
    
    var isAuthEnabled: PassthroughSubject<Bool, Error>
    
    @Published var email = ""
    @Published var password = ""
    
    let emailMessagePublisher = PassthroughSubject<String, Never>()
    let passwordMessagePublisher = PassthroughSubject<String, Never>()
    
}

extension SignInViewModel: SignInViewModelInput {
    
    func signInButtonTapped() {
        authUserService
            .signIn(email: email, password: password)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.isAuthEnabled.send(false)
                    self?.coordinator.showErrorAlert(error: ResponseError.registrationError)
                case .finished:
                    self?.isAuthEnabled.send(true)
                }
            }, receiveValue: { _ in })
            .store(in: cancelBag)
    }
    
}
