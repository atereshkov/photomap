//
//  UsernameValidationError.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 30.04.21.
//

import Foundation

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
