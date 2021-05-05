//
//  UsernameValidator.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 30.04.21.
//

import Combine

class UsernameValidator {
  
    func isUsernameValid(_ input: String) -> AnyPublisher<UsernameValidationResult, Never> {
        guard !input.isEmpty else {
            return Just(.empty).eraseToAnyPublisher()
        }
        guard input.count > 2 else {
            return Just(.short).eraseToAnyPublisher()
        }
 
        return Just(.valid).eraseToAnyPublisher()
    }
    
}
