//
//  SignUpViewModel.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/19/21.
//

import FirebaseAuth
import Combine

class SignUpViewModel: SignUpViewModelType {
   
    private(set) weak var coordinator: SignUpCoordinator!
    
    private let cancelBag = CancelBag()
    private let authUserService: AuthUserServiceType
    private let firestoreService: FirestoreServiceType
    private let validationService: ValidationServiceType
    private let activityIndicator = ActivityIndicator()
    
    // MARK: - Input
    @Published var email = ""
    @Published var password = ""
    @Published var username = ""
    
    private(set) var viewDidDisappearSubject = PassthroughSubject<Void, Never>()
    private(set) var signUpButtonSubject = PassthroughSubject<UIControl, Never>()
    private let registerUserSubject = PassthroughSubject<Void, Never>()
    
    // MARK: Output
    @Published var usernameError: String?
    @Published var emailError: String?
    @Published var passwordError: String?
    @Published var isRegistrationEnabled = false
    var loadingPublisher: AnyPublisher<Bool, Never> {
        activityIndicator.loading
    }

    init(diContainer: DIContainerType, coordinator: SignUpCoordinator) {
        self.authUserService = diContainer.resolve()
        self.firestoreService = diContainer.resolve()
        self.coordinator = coordinator
        self.validationService = diContainer.resolve()
        
        transform()
    }

    private func transform() {
        $username
            .flatMap { [unowned self] username in
                self.validationService.validateUsername(username)
            }
            .map { $0.localized }
            .receive(on: DispatchQueue.main)
            .assign(to: \.usernameError, on: self)
            .store(in: cancelBag)
        
        $email
            .flatMap { [unowned self] email in
                self.validationService.validateEmail(email)
            }
            .map { $0.localized }
            .receive(on: DispatchQueue.main)
            .assign(to: \.emailError, on: self)
            .store(in: cancelBag)
        
        $password
            .flatMap { [unowned self] password in
                self.validationService.validatePassword(password)
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
        
        registerUserSubject.sink(receiveValue: { [weak self] in
            guard let username = self?.username, let email = self?.email else { return }
            let user = User(name: username, email: email)
            self?.registerUser(user)
        })
        .store(in: cancelBag)
        
        viewDidDisappearSubject
            .subscribe(coordinator.viewDidDisappearSubject)
            .store(in: cancelBag)
    }
    
    deinit {
        cancelBag.cancel()
    }
}

extension SignUpViewModel {
    
    private func signUpButtonTapped() {
        authUserService
            .signUp(email: email, password: password)
            .receive(on: DispatchQueue.main)
            .trackActivity(activityIndicator)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.coordinator.showErrorAlertSubject.send(ResponseError(error))
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] in
                self?.registerUserSubject.send()
            })
            .store(in: cancelBag)
    }
    
    private func registerUser(_ user: User) {
        firestoreService.saveUserIntoDatabase(user)
            .receive(on: DispatchQueue.main)
            .trackActivity(activityIndicator)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.coordinator.showErrorAlertSubject.send(error)
                case .finished:
                    break
                }
            }, receiveValue: { [weak self ] in
                self?.coordinator.showMapSubject.send()
            })
            .store(in: cancelBag)
    }
}
