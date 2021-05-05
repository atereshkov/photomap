//
//  EmailValidatorTest.swift
//  PhotoMapTests
//
//  Created by Krystsina Kurytsyna on 5.05.21.
//

import XCTest
import Combine
@testable import PhotoMap

class EmailValidatorTests: XCTestCase {
    
    var emailValidator: EmailValidator!
    let cancelBag = CancelBag()
    
    override func setUp() {
        super.setUp()
        
        emailValidator = EmailValidator()
    }
    
    func testIsEmailValidWithEmptyInput() {
        let expected = EmailValidationResult.empty
        var actual: EmailValidationResult?
        
        emailValidator.isEmailValid("")
            .sink { result in
                actual = result
            }
            .store(in: cancelBag)
        XCTAssertEqual(actual, expected)
    }
    
    func testIsEmailValidWithoutAtSign() {
        let expected = EmailValidationResult.invalid
        var actual: EmailValidationResult?
        
        emailValidator.isEmailValid("example.com")
            .sink { result in
                actual = result
            }
            .store(in: cancelBag)
        XCTAssertEqual(actual, expected)
    }
    
    func testIsEmailValidWithoutDomain() {
        let expected = EmailValidationResult.invalid
        var actual: EmailValidationResult?
        
        emailValidator.isEmailValid("example@")
            .sink { result in
                actual = result
            }
            .store(in: cancelBag)
        XCTAssertEqual(actual, expected)
    }
    
    func testIsEmailValidWithValidInput() {
        let expected = EmailValidationResult.valid
        var actual: EmailValidationResult?
        
        emailValidator.isEmailValid("example@gmail.com")
            .sink { result in
                actual = result
            }
            .store(in: cancelBag)
        XCTAssertEqual(actual, expected)
    }
    
}
