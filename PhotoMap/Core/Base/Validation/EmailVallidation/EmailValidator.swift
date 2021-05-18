//
//  EmailValidator.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/27/21.
//

import Combine

class EmailValidator {
  
    func isEmailValid(_ input: String) -> AnyPublisher<EmailValidationResult, Never> {
        guard !input.isEmpty else {
            return Just(.empty).eraseToAnyPublisher()
        }
        guard input.isEmail else {
            return Just(.invalid).eraseToAnyPublisher()
        }

        return Just(.valid).eraseToAnyPublisher()
    }
    
}
