//
//  PasswordValidationError.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/27/21.
//

import Foundation

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

