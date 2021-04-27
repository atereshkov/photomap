//
//  EmailValidator.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/27/21.
//

import Combine

class EmailValidator {
    
    static func isEmailValid(input: String) -> AnyPublisher<Bool, EmailValidationError?> {
        return input
            .map { email in
                guard email.isEmpty else {
                    return EmailValidationError.isEmpty>
                }
                
                guard email.count > 2 else {
                    EmailValidationError.shortEmail
                }
                
                guard email.isEmail else {
                    return EmailValidationError.invalidEmail
                }
                
                return true
            }
            .eraseToAnyPublisher()
    }
    
}
