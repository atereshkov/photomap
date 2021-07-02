//
//  AppCoordinatorMock.swift
//  PhotoMapTests
//
//  Created by Krystsina Kurytsyna on 10.05.21.
//

import Combine
import UIKit

@testable import PhotoMap
class AppCoordinatorMock: AppCoordinatorType {
    
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController = UINavigationController()
    
    private var authListener: AuthListenerType
    private var diContainer: DIContainerType
    
    private var cancelBag: CancelBag
    
    var startCalled = false
    var showMapCalled = false
    var showAuthCalled = false
    var showInitialCalled = false
    var startMainScreenCalled = false
    var logoutCalled = false
    
    init(diContainer: DIContainerType) {
        self.diContainer = diContainer
        self.authListener = diContainer.resolve()
        self.cancelBag = CancelBag()
    }
    
    func start() {
        startCalled = true
    }
    
    func showMap() {
        showMapCalled = true
    }
    
    func showAuth() {
        showAuthCalled = true
    }
    
    func showInitial() {
        showInitialCalled = true
    }
    
    func logout() {
        logoutCalled = true
    }
    
    func startMainScreen(isUserAuthorized: Bool) {
        startMainScreenCalled = true
        
        if isUserAuthorized {
            self.showMap()
        } else {
            self.showAuth()
        }
    }
    
}
