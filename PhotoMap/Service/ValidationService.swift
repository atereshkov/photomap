//
//  ValidationService.swift
//  PhotoMap
//
//  Created by yurykasper on 30.06.21.
//

import Foundation

protocol ValidationServiceType {
    var emailValidator: EmailValidator { get }
    var passwordValidator: PasswordValidator { get }
    var usernameValidator: UsernameValidator { get }
}

final class ValidationService: ValidationServiceType {
    let emailValidator: EmailValidator
    let passwordValidator: PasswordValidator
    let usernameValidator: UsernameValidator
    
    init(emailValidator: EmailValidator, passwordValidator: PasswordValidator, usernameValidator: UsernameValidator) {
        self.emailValidator = emailValidator
        self.passwordValidator = passwordValidator
        self.usernameValidator = usernameValidator
    }
}
