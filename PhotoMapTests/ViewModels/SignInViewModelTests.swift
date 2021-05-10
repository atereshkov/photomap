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
        
    }
    
    func test_SignInSucceeded() {
        
    }
    
}
