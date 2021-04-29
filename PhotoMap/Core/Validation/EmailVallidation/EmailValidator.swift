//
//  EmailValidator.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/27/21.
//

import Combine

class EmailValidator {
    
//    func isEmailValid(input: String) -> AnyPublisher<Bool, EmailValidationError> {
//        guard !input.isEmpty else {
//            return Fail(error: .emptyEmail).eraseToAnyPublisher()
//        }
//        guard input.count > 2 else {
//            return Fail(error: .shortEmail).eraseToAnyPublisher()
//        }
//        guard input.isEmail else {
//            return Fail(error: .invalidEmail).eraseToAnyPublisher()
//        }
//        return Result.success(true).publisher.eraseToAnyPublisher()
//    }
    
    func isEmailValid(_ input: String) -> AnyPublisher<EmailValidationResult, Never> {
        guard !input.isEmpty else {
            return Just(.empty).eraseToAnyPublisher()
        }
        guard input.count > 2 else {
            return Just(.short).eraseToAnyPublisher()
        }
        guard input.isEmail else {
            return Just(.invalid).eraseToAnyPublisher()
        }
//        return Result.success(.valid).publisher.eraseToAnyPublisher()
        return Just(.valid).eraseToAnyPublisher()
    }
    
}
