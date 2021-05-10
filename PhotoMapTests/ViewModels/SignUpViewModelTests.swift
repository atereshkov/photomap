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
    
    func test_SignInButtonWithValidCredentials_ShouldBeEnabled() {
        var isEnabled = false
        
        viewModel.$isRegistrationEnabled
            .map { $0 }
            .sink { access in
                    isEnabled = access
                }
            
            .store(in: cancelBag)
        
        viewModel.username = "krokonox"
        viewModel.email = "example@gmail.com"
        viewModel.password = "12345"
        
        print(isEnabled)
        XCTAssertTrue(isEnabled)
    }
    
    func test_SignInButtonWithInvalidEmail_ShouldNotBeEnabled() {
        var isEnabled = false
        
        viewModel.$isRegistrationEnabled
            .map { $0 }
            .sink { access in
                    isEnabled = access
                }
            
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
            .map { $0 }
            .sink { access in
                    isEnabled = access
                }
            
            .store(in: cancelBag)
        
        viewModel.username = "krokonox"
        viewModel.email = "example@gmail.com"
        viewModel.password = "1"
 
        print(isEnabled)
        XCTAssertTrue(isEnabled)
    }
    
    func test_SignInButtonEnabledWithInvalidUsername_ShouldNotBeEnabled() {
        var isEnabled = false
      
        viewModel.$isRegistrationEnabled
            .map { $0 }
            .sink { access in
                    isEnabled = access
                }
            
            .store(in: cancelBag)
        
        viewModel.username = "k"
        viewModel.email = "example@gmail.com"
        viewModel.password = "1234"
        
        print(isEnabled)
        XCTAssertTrue(isEnabled)
    }
    
}
