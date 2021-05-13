//
//  AuthCoordinatorMock.swift
//  PhotoMapTests
//
//  Created by Krystsina Kurytsyna on 10.05.21.
//

import UIKit

@testable import PhotoMap
class AuthCoordinatorMock: AuthCoordinatorType {
    
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController = UINavigationController()
    
    private var appCoordinator: AppCoordinatorType?
    private var diContainer: DIContainerType
    
    var startCalled = false
    var openSignUpScreenCalled = false
    var showErrorAlertCalled = false
    var showMapCalled = false
    var closeScreenCalled = false
    
    init(appCoordinator: AppCoordinatorType, diContainer: DIContainerType) {
        self.appCoordinator = appCoordinator
        self.diContainer = diContainer
    }
    
    func start() -> UIViewController {
        startCalled = true
        
        return UIViewController()
    }
    
    func openSignUpScreen() {
        openSignUpScreenCalled = true
    }
    
    func showErrorAlert(error: ResponseError) {
        showErrorAlertCalled = true
    }
    
    func showMap() {
        showMapCalled = true
    }
    
    func closeScreen() {
        closeScreenCalled = true
    }
    
}
