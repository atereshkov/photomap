//
//  SignInViewModelTests.swift
//  PhotoMapTests
//
//  Created by Krystsina Kurytsyna on 4.05.21.
//

import XCTest
import Combine

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
        let authCoordinator = AuthCoordinator(appCoordinator: AppCoordinator(diContainer: diContainer), diContainer: diContainer)
        viewModel = SignInViewModel(diContainer: diContainer, coordinator: authCoordinator, emailValidator: emailValidator, passwordValidator: passwordValidator)
        cancelBag = CancelBag()
    }

    override func tearDownWithError() throws {
        expectation = nil
        emailValidator = nil
        viewModel = nil
        cancelBag = nil
    }
    
    func testSignInButtonEnabled_WithValidCredentialsProvided() {
//        var isEnabled = false
//        @Published var isAuthEnabled = false
//        let expectationSuccess = self.expectation(description: "'Sign In' button is enabled")
//        let startVaidation = PublishRelay<Void>()
//
//        // Act
//        startVaidation
//            .withLatestFrom(viewModel.isAuthEnabled.asObservable())
//            .subscribe(onNext: { access in
//                isEnable = access
//                expectationSuccess.fulfill()
//            })
//            .disposed(by: disposeBag)
//
//        viewModel.emailPublishSubject.accept("test@eee.rr")
//        viewModel.passwordPublishSubject.accept("password")
//        startVaidation.accept(())
//
//        wait(for: [expectationSuccess], timeout: 0.1)
//
//        // Assert
//        XCTAssertTrue(isEnable)
    }
}
