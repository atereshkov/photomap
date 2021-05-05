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
    
    func testIsPasswordValidWithEmptyInput() {
        let expected = PasswordValidationResult.empty
        var actual: PasswordValidationResult?
        
        passwordValidator.isPasswordValid("")
            .sink { result in
                actual = result
            }
            .store(in: cancelBag)
        XCTAssertEqual(actual, expected)
    }
    
    func testIsPasswordValidWithShortInput() {
        let expected = PasswordValidationResult.short
        var actual: PasswordValidationResult?
        
        passwordValidator.isPasswordValid("123")
            .sink { result in
                actual = result
            }
            .store(in: cancelBag)
        XCTAssertEqual(actual, expected)
    }
    
    func testIsPasswordValidWithValidInput() {
        let expected = PasswordValidationResult.valid
        var actual: PasswordValidationResult?
        
        passwordValidator.isPasswordValid("1672")
            .sink { result in
                actual = result
            }
            .store(in: cancelBag)
        XCTAssertEqual(actual, expected)
    }
    
}
