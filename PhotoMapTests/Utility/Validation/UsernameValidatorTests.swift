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
    
    func test_UsernameWithEmptyInput_ShouldNotBeValid() {
        let expected = UsernameValidationResult.empty
        var actual: UsernameValidationResult?
        
        usernameValidator.isUsernameValid("")
            .sink { result in
                actual = result
            }
            .store(in: cancelBag)
        XCTAssertEqual(actual, expected)
    }
    
    func test_UsernameWithShortInput_ShouldNotBeValid() {
        let expected = UsernameValidationResult.short
        var actual: UsernameValidationResult?
        
        usernameValidator.isUsernameValid("ja")
            .sink { result in
                actual = result
            }
            .store(in: cancelBag)
        XCTAssertEqual(actual, expected)
    }
    
    func test_UsernameWithValidInput_ShouldBeValid() {
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
