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
    var usernameValidator: UsernameValidator!
    var emailValidator: EmailValidator!
    var passwordValidator: PasswordValidator!
    var cancelBag: CancelBag!
    
    override func setUpWithError() throws {
        usernameValidator = UsernameValidator()
        emailValidator = EmailValidator()
        passwordValidator = PasswordValidator()
        diContainer = DIContainerMock()
        let authCoordinator = AuthCoordinator(appCoordinator: AppCoordinator(diContainer: diContainer),
                                              diContainer: diContainer)
        viewModel = SignUpViewModel(diContainer: diContainer,
                                    coordinator: authCoordinator, usernameValidator: usernameValidator,
                                    emailValidator: emailValidator,
                                    passwordValidator: passwordValidator)
        cancelBag = CancelBag()
    }

    override func tearDownWithError() throws {
        emailValidator = nil
        viewModel = nil
        cancelBag = nil
    }
    
    func testIsRegistrationEnabled_WithValidCredentials_ShouldBeEnabled() {
        var isEnabled = false
        
        viewModel.$isRegistrationEnabled
            .sink { isEnabled = $0 }
            .store(in: cancelBag)
        
        viewModel.username = "krokonox"
        viewModel.email = "example@gmail.com"
        viewModel.password = "12345"

        XCTAssertTrue(isEnabled)
    }
    
    func test_SignInButtonWithInvalidEmail_ShouldNotBeEnabled() {
        var isEnabled = false
        
        viewModel.$isRegistrationEnabled
            .sink { isEnabled = $0 }
            .store(in: cancelBag)
        
        viewModel.username = "krokonox"
        viewModel.email = "examplegmail.com"
        viewModel.password = "12345"
        
        print(isEnabled)
        XCTAssertTrue(isEnabled)
    }
    
    func test_SignInButtonWithInvalidPassword_ShouldNotBeEnabled() {
        var isEnabled = false
     
        viewModel.$isRegistrationEnabled
            .sink { isEnabled = $0 }
            .store(in: cancelBag)
        
        viewModel.username = "krokonox"
        viewModel.email = "example@gmail.com"
        viewModel.password = "1"
 
        print(isEnabled)
        XCTAssertTrue(isEnabled)
    }
    
    func testSignUpButtonEnabled_WithInvalidUsername_ShouldNotBeEnabled() {
        var isEnabled = false
      
        viewModel.$isRegistrationEnabled
            .sink { isEnabled = $0 }
            .store(in: cancelBag)
        
        viewModel.username = "k"
        viewModel.email = "example@gmail.com"
        viewModel.password = "1234"
        
        print(isEnabled)
        XCTAssertTrue(isEnabled)
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
}
