//
//  ProfileCoordinator.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/19/21.
//

import UIKit
import Combine

class ProfileCoordinator: Coordinator {
    // MARK: - Variables
    private(set) var childCoordinators = [Coordinator]()
    private(set) var navigationController = UINavigationController()
    private let authService: AuthUserServiceType
    private let fileManager: FileManagerServiceType
    private let diContainer: DIContainerType
    private let cancelBag = CancelBag()
    
    private(set) var showLogoutAlertSubject = PassthroughSubject<String, Never>()
    private(set) var showErrorSubject = PassthroughSubject<GeneralErrorType, Never>()
    private(set) var didTapLogoutSubject = PassthroughSubject<Void, Never>()
    
    // MARK: - Lifecycle
    init(diContainer: DIContainerType) {
        self.diContainer = diContainer
        self.authService = diContainer.resolve()
        self.fileManager = diContainer.resolve()
        bind()
    }
    
    private func bind() {
        showLogoutAlertSubject.sink(receiveValue: { [weak self] email in
            self?.showLogoutAlert(with: email)
        })
        .store(in: cancelBag)
        
        showErrorSubject.sink(receiveValue: { [weak self] error in
            self?.showErrorAlert(error: error)
        })
        .store(in: cancelBag)
    }
    
    @discardableResult
    func start() -> UIViewController {
        let viewModel = ProfileViewModel(coordinator: self, diContainer: diContainer)
        let profileVC = ProfileViewController.newInstanse(viewModel: viewModel)
        profileVC.tabBarItem.title = L10n.Main.TabBar.Profile.title
        profileVC.tabBarItem.image = UIImage(systemName: "person.crop.circle")
        navigationController.pushViewController(profileVC, animated: true)
        
        return navigationController
    }
    
    // MARK: - Helpers
    func showLogoutAlert(with email: String) {
        let alert = UIAlertController(title: L10n.Profile.Alert.Logout.title(email),
                                      message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: L10n.Profile.Alert.Logout.Action.cancel, style: .default)
        let logoutAction = UIAlertAction(title: L10n.Logout.Button.Title.logOut, style: .destructive) { [weak self] _ in
            self?.logoutFromAccount()
        }
        alert.addAction(cancelAction)
        alert.addAction(logoutAction)
        navigationController.present(alert, animated: true)
    }
    
    private func logoutFromAccount() {
        guard let scene = UIApplication.shared.connectedScenes.first else { return }
        guard let sceneDelegate = scene.delegate as? SceneDelegate else { return }
        guard let window = sceneDelegate.window else { return }
        guard let appCoordinator = sceneDelegate.appCoordinator else { return }
        UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromLeft) { [weak self] in
            self?.didTapLogoutSubject.send()
            self?.navigationController.dismiss(animated: true)
            appCoordinator.logout()
        }
    }
}
