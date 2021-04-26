//
//  AlertError.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/15/21.
//

import Foundation

enum AlertError: GeneralErrorType {
    
    case incorrectCredentials
    case networtConnection
    case other(message: String)

    var title: String {
        L10n.error
    }

    var message: String {
        switch self {
        case .incorrectCredentials:
            return L10n.SignUp.ErrorAlert.Title.incorrectPassword
        case .networtConnection:
            return L10n.InternetError.ErrorAlert.Title.noNetworkConnection
        case .other(let message):
            return message
        }
    }
    
}
