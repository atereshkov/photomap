//
//  SignInViewModelTests.swift
//  PhotoMapTests
//
//  Created by Dzmitry Makarevich on 6/2/21.
//

import XCTest
import Combine
@testable import PhotoMap

class SignInViewModelTests: XCTestCase {
    
    var viewModel: SignInViewModel!
    var diContainer: DIContainerType!
    var emailValidator: EmailValidator!
    var passwordValidator: PasswordValidator!
    var cancelBag: CancelBag!

    var authService: AuthUserServiceMock!
    var authListener: AuthListenerMock!
    var authCoordinator: AuthCoordinator!
    
    override func setUpWithError() throws {
        emailValidator = EmailValidator()
        passwordValidator = PasswordValidator()

        diContainer = DIContainerMock()

        let authServiceDI: AuthUserServiceType = diContainer.resolve()
        let authListenerDI: AuthListenerType = diContainer.resolve()
        authService = authServiceDI as? AuthUserServiceMock
        authListener = authListenerDI as? AuthListenerMock

        let appCoordinator = AppCoordinator(diContainer: diContainer)
        authCoordinator = AuthCoordinator(appCoordinator: appCoordinator, diContainer: diContainer)

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
    
    func testIsAuthEnabled_WithValidCredentials_ShouldBeEnabled() {
        let expectation = XCTestExpectation()
        var isEnabled = false

        viewModel.$isAuthEnabled
            .dropFirst()
            .sink { access in
                isEnabled = access
                expectation.fulfill()
            }
            .store(in: cancelBag)
        viewModel.email = "example@gmail.com"
        viewModel.password = "123456"
        
        wait(for: [expectation], timeout: 0.1)
        XCTAssertTrue(isEnabled)
    }
    
    func testIsAuthEnabled_WithInvalidEmail_ShouldNotBeEnabled() {
        var isEnabled = false
      
        viewModel.$isAuthEnabled
            .sink { isEnabled = $0 }
            .store(in: cancelBag)
        
        viewModel.email = "examplegmail.com"
        viewModel.password = "12345"

        XCTAssertTrue(isEnabled)
    }
    
    func testIsAuthEnabled_WithInvalidPassword_ShouldNotBeEnabled() {
        var isEnabled = false
      
        viewModel.$isAuthEnabled
            .sink { isEnabled = $0 }
            .store(in: cancelBag)
        
        viewModel.email = "example@gmail.com"
        viewModel.password = "1"

        XCTAssertTrue(isEnabled)
    }
    
    func testSignInButtonTapped_WithInvalidCredential_ShouldShowError() {
        // Arrange
        let expectation = XCTestExpectation()
        var showErrorAlertCalled = false
        viewModel.email = "example.gmail.com"
        viewModel.password = "valid"
        authService.signInError = .signInFailure
        XCTAssertFalse(authService.signInCalled)

        // Act
        authCoordinator.showErrorAlertSubject
            .sink { _ in
                showErrorAlertCalled = true
                expectation.fulfill()
            }
            .store(in: cancelBag)
        viewModel.signInButtonSubject.send(UIButton())

        // Assert
        wait(for: [expectation], timeout: 1)
        XCTAssertTrue(authService.signInCalled)
        XCTAssertTrue(showErrorAlertCalled)
    }
    
    func testSignInButtonTapped_WithValidCredential_ShouldShowMap() {
        // Arrange
        let expectation = XCTestExpectation()
        var showMapCalled = false
        viewModel.email = "example@gmail.com"
        viewModel.password = "valid"
        XCTAssertFalse(authService.signInCalled)
        
        // Act
        authCoordinator.showMapSubject
            .sink { _ in
                showMapCalled = true
                expectation.fulfill()
            }
            .store(in: cancelBag)
        viewModel.signInButtonSubject.send(UIButton())
        
        // Arrange
        wait(for: [expectation], timeout: 1)
        XCTAssertTrue(authService.signInCalled)
        XCTAssertTrue(showMapCalled)
    }

    func testSignUpButtonTapped_ShouldShowSignUpScreen() {
        // Arrange
        let expectation = XCTestExpectation()
        var isShowSignUpScreen = false

        // Act
        authCoordinator.showSignUpSubject
            .sink { _ in
                isShowSignUpScreen = true
                expectation.fulfill()
            }
            .store(in: cancelBag)
        viewModel.signUpButtonSubject.send(UIControl())

        // Assert
        wait(for: [expectation], timeout: 1)
        XCTAssertTrue(isShowSignUpScreen)
    }

    func testSignInButtonTapped_ShouldShowActivityIndicator() {
        // Arrange
        let expectation = XCTestExpectation()
        let expectedIsShow = [false, true, false]
        var receiveIsShow: [Bool] = []
        var count: Int = 0

        // Act
        viewModel.loadingPublisher
            .sink { isLoading in
                receiveIsShow.append(isLoading)
                count += 1
                if count == 3 {
                    expectation.fulfill()
                }
            }
            .store(in: cancelBag)
        viewModel.signInButtonSubject.send(UIControl())

        // Assert
        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(receiveIsShow, expectedIsShow)
    }
}
