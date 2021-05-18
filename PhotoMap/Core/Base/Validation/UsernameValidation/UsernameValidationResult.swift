//
//  UsernameValidationResult.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4.05.21.
//

import Foundation

enum UsernameValidationResult {
    
    case empty
    case short
    case valid
    
    var localized: String? {
        switch self {
        case .empty:
            return L10n.UsernameValidation.ErrorAlert.emptyUsername
        case .short:
            return L10n.UsernameValidation.ErrorAlert.shortUsername
        case .valid:
            return nil
        }
    }
    
}
