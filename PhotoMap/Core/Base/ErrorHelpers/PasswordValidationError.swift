//
//  PasswordValidationError.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/27/21.
//

import Foundation

enum PasswordValidationResult {
    
    case empty
    case short
    case valid
    
    var localized: String? {
        switch self {
        case .empty:
            return L10n.PasswordValidation.ErrorAlert.emptyPassword
        case .short:
            return L10n.PasswordValidation.ErrorAlert.shortPassword
        case .valid:
            return nil
        }
    }
    
}

enum PasswordValidationError: GeneralErrorType {
    
    case emptyPassword
    case shortPassword

    var title: String {
        L10n.error
    }

    var message: String {
        switch self {
        case .emptyPassword:
            return L10n.PasswordValidation.ErrorAlert.emptyPassword
        case .shortPassword:
            return L10n.PasswordValidation.ErrorAlert.shortPassword
        }
    }
    
}

