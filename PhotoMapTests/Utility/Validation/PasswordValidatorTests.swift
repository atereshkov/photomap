//
//  PasswordValidatorTests.swift
//  PhotoMapTests
//
//  Created by Krystsina Kurytsyna on 5.05.21.
//

import XCTest
import Combine
@testable import PhotoMap

class PasswordValidatorTests: XCTestCase {
    
    var passwordValidator: PasswordValidator!
    let cancelBag = CancelBag()
    
    override func setUp() {
        super.setUp()
        
        passwordValidator = PasswordValidator()
    }
    
    func test_PasswordWithEmptyInput_ShouldNotBeValid() {
        let expected = PasswordValidationResult.empty
        var actual: PasswordValidationResult?
        
        passwordValidator.isPasswordValid("")
            .sink { result in
                actual = result
            }
            .store(in: cancelBag)
        XCTAssertEqual(actual, expected)
    }
    
    func test_PasswordWithShortInput_ShouldNotBeValid() {
        let expected = PasswordValidationResult.short
        var actual: PasswordValidationResult?
        
        passwordValidator.isPasswordValid("123")
            .sink { result in
                actual = result
            }
            .store(in: cancelBag)
        XCTAssertEqual(actual, expected)
    }
    
    func test_PasswordWithValidInput_ShouldBeValid() {
        let expected = PasswordValidationResult.valid
        var actual: PasswordValidationResult?
        
        passwordValidator.isPasswordValid("167275")
            .sink { result in
                actual = result
            }
            .store(in: cancelBag)
        XCTAssertEqual(actual, expected)
    }
    
}
