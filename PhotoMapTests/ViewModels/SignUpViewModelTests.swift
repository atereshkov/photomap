//
//  SignUpViewModelTests.swift
//  PhotoMapTests
//
//  Created by Krystsina Kurytsyna on 6.05.21.
//

import XCTest
import Combine
@testable import PhotoMap

class SignUpViewModelTests: XCTestCase {
    var viewModel: SignUpViewModel!
    var diContainer: DIContainerType!
    var authService: AuthUserServiceMock!
    var authCoordinator: AuthCoordinator!
    var usernameValidator: UsernameValidator!
    var emailValidator: EmailValidator!
    var passwordValidator: PasswordValidator!
    var cancelBag: CancelBag!
    
    override func setUpWithError() throws {
        usernameValidator = UsernameValidator()
        emailValidator = EmailValidator()
        passwordValidator = PasswordValidator()
        diContainer = DIContainerMock()
        
        let authServiceDI: AuthUserServiceType = diContainer.resolve()
        authService = authServiceDI as? AuthUserServiceMock
        
        authCoordinator = AuthCoordinator(appCoordinator: AppCoordinator(diContainer: diContainer),
                                          diContainer: diContainer)
        viewModel = SignUpViewModel(diContainer: diContainer,
                                    coordinator: authCoordinator, usernameValidator: usernameValidator,
                                    emailValidator: emailValidator,
                                    passwordValidator: passwordValidator)
        cancelBag = CancelBag()
    }

    override func tearDownWithError() throws {
        viewModel = nil
        diContainer = nil
        authCoordinator = nil
        usernameValidator = nil
        emailValidator = nil
        passwordValidator = nil
        cancelBag = nil
    }

    // MARK: - IsRegistrationEnabled tests
    func testIsRegistrationEnabled_WithValidCredentials_ShouldBeEnabled() {
        // Arrange
        let expectation = XCTestExpectation()
        var isEnabled = false
        
        // Act
        viewModel.$isRegistrationEnabled
            .dropFirst()
            .sink { access in
                isEnabled = access
                expectation.fulfill()
            }
            .store(in: cancelBag)
        
        viewModel.username = "krokonox"
        viewModel.email = "example@gmail.com"
        viewModel.password = "123456"
        
        // Assert
        wait(for: [expectation], timeout: 0.5)
        XCTAssertTrue(isEnabled)
    }
    
    func testIsRegistrationEnabled_WithInvalidEmail_ShouldNotBeEnabled() {
        // Arrange
        let expectation = XCTestExpectation()
        var isEnabled = true
        
        // Act
        viewModel.$isRegistrationEnabled
            .dropFirst()
            .sink { access in
                isEnabled = access
                expectation.fulfill()
            }
            .store(in: cancelBag)
        
        viewModel.username = "krokonox"
        viewModel.email = "examplegmail.com"
        viewModel.password = "123456"
        
        // Assert
        wait(for: [expectation], timeout: 0.1)
        XCTAssertFalse(isEnabled)
    }
    
    func testIsRegistrationEnabled_WithInvalidPassword_ShouldNotBeEnabled() {
        // Arrange
        let expectation = XCTestExpectation()
        var isEnabled = true
        
        // Act
        viewModel.$isRegistrationEnabled
            .dropFirst()
            .sink { access in
                isEnabled = access
                expectation.fulfill()
            }
            .store(in: cancelBag)
        
        viewModel.username = "krokonox"
        viewModel.email = "example@gmail.com"
        viewModel.password = "12345"
        
        // Assert
        wait(for: [expectation], timeout: 0.1)
        XCTAssertFalse(isEnabled)
    }
    
    func testIsRegistrationEnabled_WithInvalidUsername_ShouldNotBeEnabled() {
        // Arrange
        let expectation = XCTestExpectation()
        var isEnabled = true

        // Act
        viewModel.$isRegistrationEnabled
            .dropFirst()
            .sink { access in
                isEnabled = access
                expectation.fulfill()
            }
            .store(in: cancelBag)
        
        viewModel.username = "k"
        viewModel.email = "example@gmail.com"
        viewModel.password = "123456"
        
        // Assert
        wait(for: [expectation], timeout: 0.1)
        XCTAssertFalse(isEnabled)
    }

    // MARK: - SignUpButton tests
    func testSignUpButtonTapped_WithInvalidCredential_ShouldShowError() {
        // Arrange
        let expectation = XCTestExpectation()
        var showErrorAlertCalled = false
        authService.signUpError = .userNotFound
        viewModel.email = "example.gmail.com"
        viewModel.password = "valid"

        // Act
        authCoordinator.showErrorAlertSubject
            .sink { _ in
                showErrorAlertCalled = true
                expectation.fulfill()
            }
            .store(in: cancelBag)
        viewModel.signUpButtonSubject.send(UIButton())

        // Assert
        wait(for: [expectation], timeout: 1)
        XCTAssertTrue(showErrorAlertCalled)
    }
    
    func testSignUpButtonTapped_WithValidCredential_ShouldShowMap() {
        // Arrange
        let expectation = XCTestExpectation()
        var showMapCalled = false
        viewModel.email = "example@gmail.com"
        viewModel.password = "valid!"
        
        // Act
        authCoordinator.showMapSubject
            .sink { _ in
                showMapCalled = true
                expectation.fulfill()
            }
            .store(in: cancelBag)
        viewModel.signUpButtonSubject.send(UIButton())
        
        // Arrange
        wait(for: [expectation], timeout: 1)
        XCTAssertTrue(showMapCalled)
    }

    func testSignUpButtonTapped_ShouldShowActivityIndicator() {
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
        viewModel.signUpButtonSubject.send(UIControl())

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

    // MARK: - UsernameError tests
    func testUsernameError_WithInvalidUsername_ShouldHasUsernameErrorMessage() {
        // Arrange
        let expectation = XCTestExpectation()
        var usernameError: String?

        // Act
        viewModel.$usernameError
            .dropFirst()
            .sink(receiveValue: { error in
                usernameError = error
                expectation.fulfill()
            })
            .store(in: cancelBag)
        viewModel.username = "Iv"

        // Assert
        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(usernameError, L10n.UsernameValidation.ErrorAlert.shortUsername)
    }

    func testUsernameError_WithValidUsername_ShouldBeNil() {
        // Arrange
        let expectation = XCTestExpectation()
        var usernameError: String?

        // Act
        viewModel.$usernameError
            .dropFirst()
            .sink(receiveValue: { error in
                usernameError = error
                expectation.fulfill()
            })
            .store(in: cancelBag)
        viewModel.username = "Ivan"

        // Assert
        wait(for: [expectation], timeout: 1)
        XCTAssertNil(usernameError)
    }
}
