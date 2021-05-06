//
//  SignInViewModelTests.swift
//  PhotoMapTests
//
//  Created by Krystsina Kurytsyna on 4.05.21.
//

import XCTest
import Combine
@testable import PhotoMap

class SignInViewModelTests: XCTestCase {
    
    var expectation: XCTestExpectation!
    var viewModel: SignInViewModel!
    var diContainer: DIContainerType!
    var emailValidator: EmailValidator!
    var passwordValidator: PasswordValidator!
    var cancelBag: CancelBag!
    
    override func setUpWithError() throws {
        expectation = XCTestExpectation()
        emailValidator = EmailValidator()
        passwordValidator = PasswordValidator()
        diContainer = DIContainer()
        let authCoordinator = AuthCoordinator(appCoordinator: AppCoordinator(diContainer: diContainer),
                                              diContainer: diContainer)
        viewModel = SignInViewModel(diContainer: diContainer,
                                    coordinator: authCoordinator,
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
      
        viewModel.$isAuthEnabled
            .map { $0 }
            .sink { access in
                    isEnabled = access
                    expectationSuccess.fulfill()
                }
            
            .store(in: cancelBag)
        
        viewModel.email = "example@gmail.com"
        viewModel.password = "12345"
        
        wait(for: [expectationSuccess], timeout: 0.1)
        print(isEnabled)
        XCTAssertTrue(isEnabled)
    }
    
    func testSignInButtonEnabled_WithInvalidEmail() {
        var isEnabled = false
        let expectationSuccess = self.expectation(description: "'Sign In' button is enabled")
      
        viewModel.$isAuthEnabled
            .map { $0 }
            .sink { access in
                    isEnabled = access
                    expectationSuccess.fulfill()
                }
            
            .store(in: cancelBag)
        
        viewModel.email = "examplegmail.com"
        viewModel.password = "12345"
        
        wait(for: [expectationSuccess], timeout: 0.1)
        print(isEnabled)
        XCTAssertTrue(isEnabled)
    }
    
    func testSignInButtonEnabled_WithInvalidPassword() {
        var isEnabled = false
        let expectationSuccess = self.expectation(description: "'Sign In' button is enabled")
      
        viewModel.$isAuthEnabled
            .map { $0 }
            .sink { access in
                    isEnabled = access
                    expectationSuccess.fulfill()
                }
            
            .store(in: cancelBag)
        
        viewModel.email = "example@gmail.com"
        viewModel.password = "1"
        
        wait(for: [expectationSuccess], timeout: 0.1)
        print(isEnabled)
        XCTAssertTrue(isEnabled)
    }
    
}
