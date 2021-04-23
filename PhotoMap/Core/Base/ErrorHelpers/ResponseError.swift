//
//  ResponseError.swift
//  PhotoMap
//
//  Created by Krystsina Kurytsyna on 4/15/21.
//

import Foundation

enum ResponseError: GeneralErrorType {
    case incorrectCredentials
    case networtConnection
    case registrationError
    case userAlreadyExists
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
        case .registrationError:
            return L10n.SignUp.ErrorAlert.Title.registrationError
        case .userAlreadyExists:
            return L10n.SignUp.ErrorAlert.Title.userAlreadyExists
        case .other(let message):
            return message
        }
    }
}
