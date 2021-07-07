//
//  ValidationService.swift
//  PhotoMap
//
//  Created by yurykasper on 30.06.21.
//

import Combine
import Foundation

protocol ValidationServiceType {
    func validateEmail(_ input: String) -> AnyPublisher<EmailValidationResult, Never>
    func validatePassword(_ input: String) -> AnyPublisher<PasswordValidationResult, Never>
    func validateUsername(_ input: String) -> AnyPublisher<UsernameValidationResult, Never>
}

final class ValidationService: ValidationServiceType {
    private let emailValidator: EmailValidator
    private let passwordValidator: PasswordValidator
    private let usernameValidator: UsernameValidator
    
    init(emailValidator: EmailValidator, passwordValidator: PasswordValidator, usernameValidator: UsernameValidator) {
        self.emailValidator = emailValidator
        self.passwordValidator = passwordValidator
        self.usernameValidator = usernameValidator
    }
    
    func validateEmail(_ input: String) -> AnyPublisher<EmailValidationResult, Never> {
        return emailValidator.isEmailValid(input)
    }
    
    func validatePassword(_ input: String) -> AnyPublisher<PasswordValidationResult, Never> {
        return passwordValidator.isPasswordValid(input)
    }
    
    func validateUsername(_ input: String) -> AnyPublisher<UsernameValidationResult, Never> {
        return usernameValidator.isUsernameValid(input)
    }
}
