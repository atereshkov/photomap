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
    
    func testIsEmailValid_WithEmptyInput() {
        let expected = EmailValidationResult.empty
        var actual: EmailValidationResult?
        
        emailValidator.isEmailValid("")
            .sink { result in
                actual = result
            }
            .store(in: cancelBag)
        XCTAssertEqual(actual, expected)
    }
    
    func testIsEmailValid_WithoutAtSign() {
        let expected = EmailValidationResult.invalid
        var actual: EmailValidationResult?
        
        emailValidator.isEmailValid("example.com")
            .sink { result in
                actual = result
            }
            .store(in: cancelBag)
        XCTAssertEqual(actual, expected)
    }
    
    func testIsEmailValid_WithoutDomain() {
        let expected = EmailValidationResult.invalid
        var actual: EmailValidationResult?
        
        emailValidator.isEmailValid("example@")
            .sink { result in
                actual = result
            }
            .store(in: cancelBag)
        XCTAssertEqual(actual, expected)
    }
    
    func testIsEmailValid_WithValidInput() {
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
