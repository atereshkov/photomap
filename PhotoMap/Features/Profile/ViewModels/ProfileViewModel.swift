//
//  ProfileViewModel.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/19/21.
//

import Combine
import FirebaseAuth
import UIKit

class ProfileViewModel: ProfileViewModelType {
    // MARK: - Variables
    private weak var coordinator: ProfileCoordinator!
    private let firestoreService: FirestoreServiceType
    private let cancelBag = CancelBag()
    
    // MARK: - Lifecycle
    init(coordinator: ProfileCoordinator, diContainer: DIContainerType) {
        self.coordinator = coordinator
        self.firestoreService = diContainer.resolve()
        transform()
    }
    
    private func transform() {
        logoutButtonSubject.sink(receiveValue: { [weak self] _ in
            guard let email = self?.email else { return }
            self?.coordinator.logoutButtonSubject.send(email)
        }).store(in: cancelBag)
        
        viewDidLoadSubject.sink(receiveValue: { [weak self] in
            self?.getUserCredentials()
        })
        .store(in: cancelBag)
        
        showErrorSubject
            .subscribe(coordinator.showErrorSubject)
            .store(in: cancelBag)
    }
    
    // MARK: - Inputs
    private let activityIndicator = ActivityIndicator()
    let showErrorSubject = PassthroughSubject<GeneralErrorType, Never>()
    let viewDidLoadSubject = PassthroughSubject<Void, Never>()
    let logoutButtonSubject = PassthroughSubject<UIBarButtonItem, Never>()
    
    // MARK: - Outputs
    @Published var username: String?
    @Published var email: String?
    var loadingPublisher: AnyPublisher<Bool, Never> {
        return activityIndicator.loading.eraseToAnyPublisher()
    }
    
    // MARK: - Helpers
    private func getUserCredentials() {
        firestoreService.getCurrentUser()
            .trackActivity(activityIndicator)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.showErrorSubject.send(error)
                }
            }, receiveValue: { [weak self] currentUser in
                self?.username = currentUser.name
                self?.email = currentUser.email
            })
            .store(in: cancelBag)
    }
}
