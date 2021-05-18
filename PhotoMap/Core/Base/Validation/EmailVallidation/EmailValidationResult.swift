//
//  EmailValidationResult.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4.05.21.
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
