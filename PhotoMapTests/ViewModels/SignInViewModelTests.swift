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
    var validationService: ValidationServiceType!
    var cancelBag: CancelBag!

    var authService: AuthUserServiceMock!
    var authListener: AuthListenerMock!
    var authCoordinator: AuthCoordinator!
    
    override func setUpWithError() throws {
        diContainer = DIContainerMock()

        let authServiceDI: AuthUserServiceType = diContainer.resolve()
        let authListenerDI: AuthListenerType = diContainer.resolve()
        validationService = diContainer.resolve()
        authService = authServiceDI as? AuthUserServiceMock
        authListener = authListenerDI as? AuthListenerMock

        let appCoordinator = AppCoordinator(window: UIWindow(), diContainer: diContainer)
        authCoordinator = AuthCoordinator(appCoordinator: appCoordinator, diContainer: diContainer)

        viewModel = SignInViewModel(diContainer: diContainer,
                                    coordinator: authCoordinator)
        cancelBag = CancelBag()
    }

    override func tearDownWithError() throws {
        validationService = nil
        viewModel = nil
        authCoordinator = nil
        cancelBag = nil
        
        super.tearDown()
    }
    
    // MARK: - IsAuthEnabled tests
    func testIsAuthEnabled_WithValidCredentials_ShouldBeEnabled() {
        // Arrange
        let expectation = XCTestExpectation()
        var isEnabled = false

        // Act
        viewModel.$isAuthEnabled
            .dropFirst()
            .sink { access in
                isEnabled = access
                expectation.fulfill()
            }
            .store(in: cancelBag)
        viewModel.email = "example@gmail.com"
        viewModel.password = "123456"
        
        // Assert
        wait(for: [expectation], timeout: 0.1)
        XCTAssertTrue(isEnabled)
    }
    
    func testIsAuthEnabled_WithInvalidEmail_ShouldNotBeEnabled() {
        // Arrange
        let expectation = XCTestExpectation()
        var isEnabled = true

        // Act
        viewModel.$isAuthEnabled
            .dropFirst()
            .sink { access in
                isEnabled = access
                expectation.fulfill()
            }
            .store(in: cancelBag)
        
        viewModel.email = "examplegmail.com"
        viewModel.password = "123456"
        
        // Assert
        wait(for: [expectation], timeout: 0.1)
        XCTAssertFalse(isEnabled)
    }
    
    func testIsAuthEnabled_WithInvalidPassword_ShouldNotBeEnabled() {
        // Arrange
        let expectation = XCTestExpectation()
        var isEnabled = false
      
        viewModel.$isAuthEnabled
            .dropFirst()
            .sink { access in
                isEnabled = access
                expectation.fulfill()
            }
            .store(in: cancelBag)
        
        // Act
        viewModel.email = "example@gmail.com"
        viewModel.password = "12345"
        
        // Assert
        wait(for: [expectation], timeout: 0.1)
        XCTAssertFalse(isEnabled)
    }
    
    // MARK: - SignInButton tests
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
                if count == expectedIsShow.count {
                    expectation.fulfill()
                }
            }
            .store(in: cancelBag)
        viewModel.signInButtonSubject.send(UIControl())

        // Assert
        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(receiveIsShow, expectedIsShow)
    }

    // MARK: - EmailError tests
    func testEmailError_WithEmptyEmail_ShouldHasEmptyEmailErrorMessage() {
        // Arrange
        let expectation = XCTestExpectation()
        var emailError: String?

        // Act
        viewModel.$emailError
            .dropFirst()
            .sink(receiveValue: { error in
                emailError = error
                expectation.fulfill()
            })
            .store(in: cancelBag)
        viewModel.email = ""

        // Assert
        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(emailError, L10n.EmailValidation.ErrorAlert.emptyEmail)
    }

    func testEmailError_WithValidEmail_ShouldBeNil() {
        // Arrange
        let expectation = XCTestExpectation()
        var emailError: String?

        // Act
        viewModel.$emailError
            .dropFirst()
            .sink(receiveValue: { error in
                emailError = error
                expectation.fulfill()
            })
            .store(in: cancelBag)
        viewModel.email = "example@dmail.com"

        // Assert
        wait(for: [expectation], timeout: 1)
        XCTAssertNil(emailError)
    }

    // MARK: - PasswordError tests
    func testPasswordError_WithInvalidPassword_ShouldHasPasswordErrorMessage() {
        // Arrange
        let expectation = XCTestExpectation()
        var passwordError: String?

        // Act
        viewModel.$passwordError
            .dropFirst()
            .sink(receiveValue: { error in
                passwordError = error
                expectation.fulfill()
            })
            .store(in: cancelBag)
        viewModel.password = "1234"

        // Assert
        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(passwordError, L10n.PasswordValidation.ErrorAlert.shortPassword)
    }

    func testPasswordError_WithValidPassword_ShouldBeNil() {
        // Arrange
        let expectation = XCTestExpectation()
        var passwordError: String?

        // Act
        viewModel.$passwordError
            .dropFirst()
            .sink(receiveValue: { error in
                passwordError = error
                expectation.fulfill()
            })
            .store(in: cancelBag)
        viewModel.password = "valild!"

        // Assert
        wait(for: [expectation], timeout: 1)
        XCTAssertNil(passwordError)
    }
}
