//
//  PasswordValidationResult.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4.05.21.
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
