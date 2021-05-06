//
//  UsernameValidatorTests.swift
//  PhotoMapTests
//
//  Created by Krystsina Kurytsyna on 5.05.21.
//

import XCTest
import Combine
@testable import PhotoMap

class UsernameValidatorTests: XCTestCase {
    
    var usernameValidator: UsernameValidator!
    let cancelBag = CancelBag()
    
    override func setUp() {
        super.setUp()
        
        usernameValidator = UsernameValidator()
    }
    
    func testIsUsernameValid_WithEmptyInput() {
        let expected = UsernameValidationResult.empty
        var actual: UsernameValidationResult?
        
        usernameValidator.isUsernameValid("")
            .sink { result in
                actual = result
            }
            .store(in: cancelBag)
        XCTAssertEqual(actual, expected)
    }
    
    func testIsUsernameValid_WithShortInput() {
        let expected = UsernameValidationResult.short
        var actual: UsernameValidationResult?
        
        usernameValidator.isUsernameValid("ja")
            .sink { result in
                actual = result
            }
            .store(in: cancelBag)
        XCTAssertEqual(actual, expected)
    }
    
    func testIsUsernameValid_WithValidInput() {
        let expected = UsernameValidationResult.valid
        var actual: UsernameValidationResult?
        
        usernameValidator.isUsernameValid("krokonox")
            .sink { result in
                actual = result
            }
            .store(in: cancelBag)
        XCTAssertEqual(actual, expected)
    }
    
}
