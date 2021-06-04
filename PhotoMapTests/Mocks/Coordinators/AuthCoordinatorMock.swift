//
//  AuthCoordinatorMock.swift
//  PhotoMapTests
//
//  Created by Krystsina Kurytsyna on 10.05.21.
//

import XCTest
import UIKit
import Combine
@testable import PhotoMap

class AuthCoordinatorMock: AuthCoordinatorType {
    private(set) var showErrorAlertSubject = PassthroughSubject<ResponseError, Never>()
    private(set) var showMapSubject = PassthroughSubject<Void, Never>()
    private(set) var showSignUpSubject = PassthroughSubject<Void, Never>()

    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController = UINavigationController()
    
    private var appCoordinator: AppCoordinatorType?
    private var diContainer: DIContainerType
    private let cancelBag = CancelBag()
    
    var startCalled = false
    var openSignUpScreenCalled = false
    var showErrorAlertCalled = false
    var showMapCalled = false
    
    init(appCoordinator: AppCoordinatorType, diContainer: DIContainerType, with exp: XCTestExpectation) {
        self.appCoordinator = appCoordinator
        self.diContainer = diContainer

        bind(with: exp)
    }
    
    func start() -> UIViewController {
        startCalled = true
        
        return UIViewController()
    }

    private func bind(with expectation: XCTestExpectation) {
        showErrorAlertSubject
            .sink { [weak self] _ in
                self?.showErrorAlertCalled = true
                expectation.fulfill()
            }
            .store(in: cancelBag)
        showMapSubject
            .sink { [weak self] _ in
                self?.showMapCalled = true
                expectation.fulfill()
            }
            .store(in: cancelBag)
        showSignUpSubject
            .sink { [weak self] _ in
                self?.openSignUpScreenCalled = true
                expectation.fulfill()
            }
            .store(in: cancelBag)
    }
}
