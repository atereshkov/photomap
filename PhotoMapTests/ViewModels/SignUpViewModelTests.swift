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
    
    var expectation: XCTestExpectation!
    var viewModel: SignUpViewModel!
    var diContainer: DIContainerType!
    var usernameValidator: UsernameValidator!
    var emailValidator: EmailValidator!
    var passwordValidator: PasswordValidator!
    var cancelBag: CancelBag!
    
    override func setUpWithError() throws {
        expectation = XCTestExpectation()
        usernameValidator = UsernameValidator()
        emailValidator = EmailValidator()
        passwordValidator = PasswordValidator()
        diContainer = DIContainer()
        let authCoordinator = AuthCoordinator(appCoordinator: AppCoordinator(diContainer: diContainer),
                                              diContainer: diContainer)
        viewModel = SignUpViewModel(diContainer: diContainer,
                                    coordinator: authCoordinator, usernameValidator: usernameValidator,
                                    emailValidator: emailValidator,
                                    passwordValidator: passwordValidator)
        cancelBag = CancelBag()
    }

    override func tearDownWithError() throws {
        expectation = nil
        emailValidator = nil
        viewModel = nil
        cancelBag = nil
    }
    
    func testSignInButtonEnabled_WithValidCredentials() {
        var isEnabled = false
        let expectationSuccess = self.expectation(description: "'Sign In' button is enabled")
      
        viewModel.$isRegistrationEnabled
            .map { $0 }
            .sink { access in
                    isEnabled = access
                    expectationSuccess.fulfill()
                }
            
            .store(in: cancelBag)
        
        viewModel.username = "krokonox"
        viewModel.email = "example@gmail.com"
        viewModel.password = "12345"
        
        wait(for: [expectationSuccess], timeout: 0.1)
        print(isEnabled)
        XCTAssertTrue(isEnabled)
    }
    
    func testSignInButtonEnabled_WithInvalidEmail() {
        var isEnabled = false
        let expectationSuccess = self.expectation(description: "'Sign In' button is enabled")
      
        viewModel.$isRegistrationEnabled
            .map { $0 }
            .sink { access in
                    isEnabled = access
                    expectationSuccess.fulfill()
                }
            
            .store(in: cancelBag)
        
        viewModel.username = "krokonox"
        viewModel.email = "examplegmail.com"
        viewModel.password = "12345"
        
        wait(for: [expectationSuccess], timeout: 0.1)
        print(isEnabled)
        XCTAssertTrue(isEnabled)
    }
    
    func testSignInButtonEnabled_WithInvalidPassword() {
        var isEnabled = false
        let expectationSuccess = self.expectation(description: "'Sign In' button is enabled")
      
        viewModel.$isRegistrationEnabled
            .map { $0 }
            .sink { access in
                    isEnabled = access
                    expectationSuccess.fulfill()
                }
            
            .store(in: cancelBag)
        
        viewModel.username = "krokonox"
        viewModel.email = "example@gmail.com"
        viewModel.password = "1"
        
        wait(for: [expectationSuccess], timeout: 0.1)
        print(isEnabled)
        XCTAssertTrue(isEnabled)
    }
    
    func testSignInButtonEnabled_WithInvalidUsername() {
        var isEnabled = false
        let expectationSuccess = self.expectation(description: "'Sign In' button is enabled")
      
        viewModel.$isRegistrationEnabled
            .map { $0 }
            .sink { access in
                    isEnabled = access
                    expectationSuccess.fulfill()
                }
            
            .store(in: cancelBag)
        
        viewModel.username = "k"
        viewModel.email = "example@gmail.com"
        viewModel.password = "1234"
        
        wait(for: [expectationSuccess], timeout: 0.1)
        print(isEnabled)
        XCTAssertTrue(isEnabled)
    }
    
}
