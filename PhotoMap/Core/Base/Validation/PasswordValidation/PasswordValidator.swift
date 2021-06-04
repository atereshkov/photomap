//
//  PasswordValidator.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/27/21.
//

import Combine

class PasswordValidator {
  
    func isPasswordValid(_ input: String) -> AnyPublisher<PasswordValidationResult, Never> {
        guard !input.isEmpty else {
            return Just(.empty).eraseToAnyPublisher()
        }
        guard input.count >= 6 else {
            return Just(.short).eraseToAnyPublisher()
        }
 
        return Just(.valid).eraseToAnyPublisher()
    }
    
}
