//
//  EmailValidationError.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/27/21.
//

import Foundation

enum EmailValidationResult {
    
    case empty
    case short
    case invalid
    case valid
    
    var localized: String? {
        switch self {
        case .empty:
            return L10n.EmailValidation.ErrorAlert.emptyEmail
        case .short:
            return L10n.EmailValidation.ErrorAlert.shortEmail
        case .invalid:
            return L10n.EmailValidation.ErrorAlert.invalidEmail
        case .valid:
            return nil
        }
    }
}

enum EmailValidationError: GeneralErrorType {
    
    case emptyEmail
    case shortEmail
    case invalidEmail

    var title: String {
        L10n.error
    }

    var message: String {
        switch self {
        case .emptyEmail:
            return L10n.EmailValidation.ErrorAlert.emptyEmail
        case .shortEmail:
            return L10n.EmailValidation.ErrorAlert.shortEmail
        case .invalidEmail:
            return L10n.EmailValidation.ErrorAlert.invalidEmail
        }
    }
    
}
