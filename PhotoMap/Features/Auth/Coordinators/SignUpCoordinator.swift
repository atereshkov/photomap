//
//  SignUpCoordinator.swift
//  PhotoMap
//
//  Created by yurykasper on 6.07.21.
//

import Combine
import UIKit

class SignUpCoordinator: Coordinator {
    // MARK: - Variables
    private(set) var childCoordinators: [Coordinator] = []
    private(set) var navigationController = UINavigationController()
    private let diContainer: DIContainerType
    private let cancelBag = CancelBag()
    private weak var view: UIViewController?
    
    weak var parentCoordinator: (SignInCoordinator & Coordinator)?
    
    private(set) var showMapSubject = PassthroughSubject<Void, Never>()
    private(set) var viewDidDisappearSubject = PassthroughSubject<Void, Never>()
    private(set) var showErrorAlertSubject = PassthroughSubject<GeneralErrorType, Never>()
    
    // MARK: - Lifecycle
    init(diContainer: DIContainerType) {
        self.diContainer = diContainer
        bind()
    }
    
    private func bind() {
        showMapSubject.sink(receiveValue: { [weak self] in
            self?.presentMapScreen()
        }).store(in: cancelBag)
        
        viewDidDisappearSubject.sink(receiveValue: { [weak self] in
            self?.viewDidDisappear()
        })
        .store(in: cancelBag)
        
        showErrorAlertSubject.sink(receiveValue: { [weak self] error in
            self?.showError(error: error)
        })
        .store(in: cancelBag)
    }
    
    // MARK: - Helpers
    @discardableResult
    func start() -> UIViewController {
        let viewModel = SignUpViewModel(diContainer: diContainer, coordinator: self)
        let signUpVC = SignUpViewController.newInstanse(viewModel: viewModel)
        view = signUpVC
        return signUpVC
    }
    
    private func presentMapScreen() {
        navigationController.dismiss(animated: true)
        parentCoordinator?.childDidFinish(self)
        parentCoordinator?.presentMapScreen()
    }
    
    private func viewDidDisappear() {
        navigationController.dismiss(animated: true)
        parentCoordinator?.childDidFinish(self)
    }
    
    private func showError(error: GeneralErrorType) {
        let alert = UIAlertController(title: error.title,
                                      message: error.message,
                                      preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: L10n.ok, style: .cancel, handler: nil)

        alert.addAction(cancelAction)
        view?.present(alert, animated: true)
    }
    
    deinit {
        cancelBag.cancel()
    }
}
