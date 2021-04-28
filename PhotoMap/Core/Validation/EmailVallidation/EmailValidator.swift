//
//  EmailValidator.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/27/21.
//

import Combine

class EmailValidator {
    
    var isEmailValid: Bool = false
    var errorMessage: EmailValidationError?
    
     func isEmailValid(input: String) -> AnyPublisher<Bool, EmailValidationError> {
        return input
            .map { email -> (Bool, EmailValidationError) in
                guard email.isEmpty else {
                    return (false, EmailValidationError.emptyEmail)
                }
                
                guard email.count > 2 else {
                    return (false, EmailValidationError.shortEmail)
                }
                
                guard email.isEmail else {
                    return (false, EmailValidationError.invalidEmail)
                }
                
                return (true, nil)
            }
            .eraseToAnyPublisher()
    }
    
}
