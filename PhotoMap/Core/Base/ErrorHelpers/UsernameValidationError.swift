//
//  UsernameValidationError.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 30.04.21.
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

enum UsernameValidationError: GeneralErrorType {
    
    case emptyUsername
    case shortUsername

    var title: String {
        L10n.error
    }

    var message: String {
        switch self {
        case .emptyUsername:
            return L10n.UsernameValidation.ErrorAlert.emptyUsername
        case .shortUsername:
            return L10n.UsernameValidation.ErrorAlert.shortUsername
        }
    }
    
}
