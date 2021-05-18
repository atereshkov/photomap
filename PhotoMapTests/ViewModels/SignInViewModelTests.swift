//
//  SignInViewModelTests.swift
//  PhotoMapTests
//
//  Created by Krystsina Kurytsyna on 4.05.21.
//

import XCTest
import Combine
import Swinject
@testable import PhotoMap

class SignInViewModelTests: XCTestCase {
    
    var viewModel: SignInViewModel!
    var diContainer: DIContainerType!
    var emailValidator: EmailValidator!
    var passwordValidator: PasswordValidator!
    var cancelBag: CancelBag!
    
    var mockContainer: Container!

    var authService: AuthUserServiceMock!
    var authListener: AuthListenerMock!
    var authCoordinator: AuthCoordinatorMock!
    
    override func setUpWithError() throws {
        emailValidator = EmailValidator()
        passwordValidator = PasswordValidator()

        authService = AuthUserServiceMock()
        authListener = AuthListenerMock()
        
        mockContainer = Container()
        mockContainer.register(AuthUserServiceType.self) { _ -> AuthUserServiceType in
            self.authService
        }.inObjectScope(.container)

        mockContainer.register(AuthListenerType.self) { _ -> AuthListenerType in
            self.authListener
        }.inObjectScope(.container)
        
        diContainer = DIContainerMock(container: mockContainer)
        
        let appCoordinator = AppCoordinatorMock(diContainer: diContainer)
        authCoordinator = AuthCoordinatorMock(appCoordinator: appCoordinator, diContainer: diContainer)

        viewModel = SignInViewModel(diContainer: diContainer,
                                    coordinator: authCoordinator,
                                    emailValidator: emailValidator,
                                    passwordValidator: passwordValidator)
        cancelBag = CancelBag()
    }

    override func tearDownWithError() throws {
        emailValidator = nil
        viewModel = nil
        authCoordinator = nil
        cancelBag = nil
        
        super.tearDown()
    }
    
    func testSignInButtonEnabled_WithValidCredentials() {
        var isEnabled = false
       
        viewModel.$isAuthEnabled
            .map { $0 }
            .sink { access in
                    isEnabled = access
                }
            
            .store(in: cancelBag)
        
        viewModel.email = "example@gmail.com"
        viewModel.password = "12345"
        
        print(isEnabled)
        XCTAssertTrue(isEnabled)
    }
    
    func testSignInButtonEnabled_WithInvalidEmail() {
        var isEnabled = false
      
        viewModel.$isAuthEnabled
            .map { $0 }
            .sink { access in
                    isEnabled = access
                }
            
            .store(in: cancelBag)
        
        viewModel.email = "examplegmail.com"
        viewModel.password = "12345"
        
        print(isEnabled)
        XCTAssertTrue(isEnabled)
    }
    
    func test_SignInButtonWithInvalidPassword_ShouldNotBeEnabled() {
        var isEnabled = false
      
        viewModel.$isAuthEnabled
            .map { $0 }
            .sink { access in
                    isEnabled = access
                }
            
            .store(in: cancelBag)
        
        viewModel.email = "example@gmail.com"
        viewModel.password = "1"
        
        print(isEnabled)
        XCTAssertTrue(isEnabled)
    }
    
    func test_SignInFailed() {
        viewModel.email = "example.gmail.com"
        viewModel.password = "valid"
        authService.signInError = .incorrectCredentials
        
        XCTAssertFalse(authService.signInCalled)
        XCTAssertFalse(authCoordinator.showErrorAlertCalled)
        XCTAssertNil(authService.signInEmailParam)
        XCTAssertNil(authService.signInPasswordParam)
        
        viewModel.signInButtonSubject.send(UIButton())

        XCTAssertTrue(authService.signInCalled)
        XCTAssertEqual(authService.signInEmailParam, "example.gmail.com")
        XCTAssertEqual(authService.signInPasswordParam, "valid")
//        XCTAssertTrue(authCoordinator.showErrorAlertCalled)
    }
    
    func test_SignInSucceeded() {
        viewModel.email = "example@gmail.com"
        viewModel.password = "valid"
        
        XCTAssertFalse(authCoordinator.closeScreenCalled)
        XCTAssertFalse(authService.signInCalled)
        XCTAssertNil(authService.signInEmailParam)
        XCTAssertNil(authService.signInPasswordParam)
        
        viewModel.signInButtonSubject.send(UIButton())
   
        XCTAssertTrue(authService.signInCalled)
        XCTAssertEqual(authService.signInEmailParam, "example@gmail.com")
        XCTAssertEqual(authService.signInPasswordParam, "valid")
//        XCTAssertTrue(authCoordinator.closeScreenCalled)
    }
    
}
